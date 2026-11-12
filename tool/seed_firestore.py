"""One-off seeding: bundled portfolio content -> Cloudinary (images) + Firestore (content).

Usage:
  flutter test test/export_content_test.dart          # writes /tmp/portfolio_content.json
  python3 tool/seed_firestore.py <cloud_name> <unsigned_upload_preset>

Firestore writes use your gcloud login (project owner), so security rules don't apply here.
Images already uploaded are cached in tool/.image_urls.json so re-runs don't re-upload.
"""
import json
import mimetypes
import os
import subprocess
import sys
import urllib.request
import uuid

PROJECT = "mohamedbh-portfolio"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CACHE = os.path.join(ROOT, "tool", ".image_urls.json")
BASE = f"https://firestore.googleapis.com/v1/projects/{PROJECT}/databases/(default)/documents"


def upload(path, cloud, preset):
    """Unsigned upload to Cloudinary; returns the secure https URL."""
    boundary = uuid.uuid4().hex
    with open(path, "rb") as f:
        data = f.read()
    mime = mimetypes.guess_type(path)[0] or "application/octet-stream"
    body = (
        f"--{boundary}\r\nContent-Disposition: form-data; name=\"upload_preset\"\r\n\r\n{preset}\r\n"
        f"--{boundary}\r\nContent-Disposition: form-data; name=\"folder\"\r\n\r\nportfolio\r\n"
        f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"{os.path.basename(path)}\"\r\n"
        f"Content-Type: {mime}\r\n\r\n"
    ).encode() + data + f"\r\n--{boundary}--\r\n".encode()
    req = urllib.request.Request(
        f"https://api.cloudinary.com/v1_1/{cloud}/image/upload",
        data=body,
        headers={"Content-Type": f"multipart/form-data; boundary={boundary}"},
    )
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.load(r)["secure_url"]


def to_value(v):
    if v is None:
        return {"nullValue": None}
    if isinstance(v, bool):
        return {"booleanValue": v}
    if isinstance(v, int):
        return {"integerValue": str(v)}
    if isinstance(v, float):
        return {"doubleValue": v}
    if isinstance(v, list):
        return {"arrayValue": {"values": [to_value(x) for x in v]}}
    if isinstance(v, dict):
        return {"mapValue": {"fields": {k: to_value(x) for k, x in v.items()}}}
    return {"stringValue": str(v)}


def write(token, collection, doc_id, data):
    req = urllib.request.Request(
        f"{BASE}/{collection}/{doc_id}",
        data=json.dumps({"fields": {k: to_value(v) for k, v in data.items()}}).encode(),
        method="PATCH",
        headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"},
    )
    urllib.request.urlopen(req, timeout=60).read()


def slug(s):
    return "".join(c if c.isalnum() else "-" for c in s.lower()).strip("-")


def main():
    cloud, preset = sys.argv[1], sys.argv[2]
    content = json.load(open("/tmp/portfolio_content.json"))
    cache = json.load(open(CACHE)) if os.path.exists(CACHE) else {}

    def url_for(asset):
        if not asset or asset.startswith("http"):
            return asset
        if asset not in cache:
            cache[asset] = upload(os.path.join(ROOT, asset), cloud, preset)
            json.dump(cache, open(CACHE, "w"), indent=1)
            print("  uploaded", asset)
        return cache[asset]

    token = subprocess.check_output(["gcloud", "auth", "print-access-token"], text=True).strip()
    for p in content["projects"]:
        p["appIcon"] = url_for(p["appIcon"])
        p["screenshots"] = [url_for(s) for s in p["screenshots"]]
        write(token, "projects", slug(p["name"]), p)
        print("project", p["name"])
    for coll in ("experiences", "education", "certifications", "reviews"):
        for i, item in enumerate(content[coll]):
            write(token, coll, f"{i:02d}", item)
        print(coll, len(content[coll]))


if __name__ == "__main__":
    main()
