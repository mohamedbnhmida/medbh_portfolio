// Newsletter from the dashboard → Brevo, one personal copy per subscriber, in the portfolio email design.

import type { ContactEnv } from "./contact";

export interface NewsletterEnv extends ContactEnv {
  FIREBASE_API_KEY: string; // dashboard's public web API key, from wrangler.toml
  ADMIN_EMAIL: string; // dashboard login allowed to send, from wrangler.toml
}

interface Newsletter {
  subject: string;
  html: string; // body from the dashboard editor (trusted: admin only)
  to: string[];
  attachment?: { name: string; content: string }; // base64
}

const EMAIL = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

/** True if the bearer token is a valid Firebase ID token of the admin (checked by Google). */
export async function isAdmin(request: Request, env: NewsletterEnv): Promise<boolean> {
  const idToken = request.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!idToken) return false;
  const res = await fetch(`https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${env.FIREBASE_API_KEY}`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ idToken }),
  });
  if (!res.ok) return false;
  const { users } = (await res.json()) as { users?: { email?: string }[] };
  return users?.[0]?.email?.toLowerCase() === env.ADMIN_EMAIL.toLowerCase();
}

export function parseNewsletter(raw: unknown): Newsletter | null {
  if (!raw || typeof raw !== "object") return null;
  const r = raw as Record<string, unknown>;
  const subject = typeof r.subject === "string" ? r.subject.trim().slice(0, 200) : "";
  const html = typeof r.html === "string" ? r.html : "";
  const to = Array.isArray(r.to) ? [...new Set(r.to.filter((e): e is string => typeof e === "string" && EMAIL.test(e)))] : [];
  const a = r.attachment as Newsletter["attachment"] | undefined;
  const attachment = a && typeof a.name === "string" && typeof a.content === "string" ? a : undefined;
  if (!subject || !html.trim() || !to.length) return null;
  return { subject, html, to, attachment };
}

const esc = (s: string) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

/** Same design as the contact email: dark navy card, blue gradient header, Orbitron headings. */
export function newsletterHtml(subject: string, body: string): string {
  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="color-scheme" content="dark">
<title>${esc(subject)}</title>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body style="margin:0;padding:0;background:#0A0F1A;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#0A0F1A;padding:32px 12px;">
<tr><td align="center">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:600px;background:#111a2e;border:1px solid #1e3a6e;border-radius:18px;overflow:hidden;font-family:Inter,Segoe UI,Arial,sans-serif;">
  <tr><td style="background:linear-gradient(135deg,#2F6BFF,#00B4FF);background-color:#2F6BFF;padding:28px 32px;">
    <div style="font-family:Orbitron,Arial,sans-serif;font-size:12px;letter-spacing:3px;color:#dbe8ff;text-transform:uppercase;">Newsletter · Mohamed Ben Hmida</div>
    <div style="font-family:Orbitron,Arial,sans-serif;font-size:24px;font-weight:700;color:#ffffff;margin-top:8px;">${esc(subject)}</div>
  </td></tr>
  <tr><td style="padding:28px 32px 8px;font-size:15px;line-height:1.65;color:#d7def0;">
    ${body}
  </td></tr>
  <tr><td align="center" style="padding:20px 32px 32px;">
    <a href="https://mohamedbenhmida-portfolio.web.app" style="display:inline-block;background:#2F6BFF;background:linear-gradient(135deg,#2F6BFF,#00B4FF);color:#ffffff;font-family:Orbitron,Arial,sans-serif;font-size:14px;font-weight:700;letter-spacing:1px;text-decoration:none;padding:14px 32px;border-radius:30px;">Visit my portfolio</a>
  </td></tr>
  <tr><td style="border-top:1px solid #1e3a6e;padding:18px 32px;text-align:center;font-size:12px;color:#6b7896;">
    You receive this because you subscribed on <a href="https://mohamedbenhmida-portfolio.web.app" style="color:#5aa0ff;text-decoration:none;">mohamedbenhmida-portfolio.web.app</a>.<br>Reply "unsubscribe" to stop receiving these emails.
  </td></tr>
</table>
</td></tr>
</table>
</body>
</html>`;
}

/** One Brevo call per 1000 recipients; each subscriber gets their own copy (no shared To/BCC). Returns how many were sent. */
export async function sendNewsletter(n: Newsletter, env: NewsletterEnv): Promise<number> {
  const htmlContent = newsletterHtml(n.subject, n.html);
  let sent = 0;
  for (let i = 0; i < n.to.length; i += 1000) {
    const batch = n.to.slice(i, i + 1000);
    const res = await fetch("https://api.brevo.com/v3/smtp/email", {
      method: "POST",
      headers: { "api-key": env.BREVO_API_KEY, "content-type": "application/json", accept: "application/json" },
      body: JSON.stringify({
        sender: { name: "Mohamed Ben Hmida", email: env.SENDER_EMAIL },
        replyTo: { email: env.CONTACT_TO, name: "Mohamed Ben Hmida" },
        subject: n.subject,
        htmlContent,
        ...(n.attachment && { attachment: [n.attachment] }),
        messageVersions: batch.map((email) => ({ to: [{ email }] })),
      }),
    });
    if (!res.ok) throw new Error(`Brevo ${res.status}: ${await res.text()}`);
    sent += batch.length;
  }
  return sent;
}
