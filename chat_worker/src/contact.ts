// Contact form → Brevo transactional email, with the portfolio-styled HTML template.

export interface ContactEnv {
  BREVO_API_KEY: string; // `npx wrangler secret put BREVO_API_KEY` (an xkeysib-… API key)
  SENDER_EMAIL: string; // verified Brevo sender, from wrangler.toml
  CONTACT_TO: string; // where messages are delivered, from wrangler.toml
}

export interface ContactForm {
  name: string;
  email: string;
  subject: string;
  message: string;
}

const LIMITS = { name: 100, email: 200, subject: 200, message: 5000 };

/** Validates and trims the browser payload; returns null if invalid. */
export function parseContact(raw: unknown): ContactForm | null {
  if (!raw || typeof raw !== "object") return null;
  const r = raw as Record<string, unknown>;
  const field = (k: keyof typeof LIMITS) => (typeof r[k] === "string" ? (r[k] as string).trim().slice(0, LIMITS[k]) : "");
  const form = { name: field("name"), email: field("email"), subject: field("subject"), message: field("message") };
  if (!form.name || !form.message || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.email)) return null;
  return form;
}

const esc = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");

/** Email in the portfolio's design: dark navy, blue accent, Orbitron headings. Table layout + inline styles for mail clients. */
export function contactEmailHtml(f: ContactForm, sentAt: Date): string {
  const n = esc(f.name), e = esc(f.email), s = esc(f.subject || "(no subject)");
  const m = esc(f.message).replace(/\n/g, "<br>");
  const initial = esc(f.name.charAt(0).toUpperCase() || "?");
  const when = sentAt.toISOString().slice(0, 16).replace("T", " ") + " UTC";
  const mailto = esc(`mailto:${encodeURIComponent(f.email)}?subject=${encodeURIComponent(`Re: ${f.subject || "your message"}`)}`);

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="color-scheme" content="dark">
<title>New portfolio message</title>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body style="margin:0;padding:0;background:#0A0F1A;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#0A0F1A;padding:32px 12px;">
<tr><td align="center">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:600px;background:#111a2e;border:1px solid #1e3a6e;border-radius:18px;overflow:hidden;font-family:Inter,Segoe UI,Arial,sans-serif;">
  <tr><td style="background:linear-gradient(135deg,#2F6BFF,#00B4FF);background-color:#2F6BFF;padding:28px 32px;">
    <div style="font-family:Orbitron,Arial,sans-serif;font-size:12px;letter-spacing:3px;color:#dbe8ff;text-transform:uppercase;">Portfolio contact</div>
    <div style="font-family:Orbitron,Arial,sans-serif;font-size:24px;font-weight:700;color:#ffffff;margin-top:8px;">New message received</div>
  </td></tr>
  <tr><td style="padding:28px 32px 8px;">
    <table role="presentation" cellpadding="0" cellspacing="0"><tr>
      <td style="width:52px;height:52px;border-radius:26px;background:#1d2d52;border:1px solid #2F6BFF;text-align:center;vertical-align:middle;font-family:Orbitron,Arial,sans-serif;font-size:22px;font-weight:700;color:#7fb2ff;">${initial}</td>
      <td style="padding-left:14px;">
        <div style="font-size:17px;font-weight:600;color:#ffffff;">${n}</div>
        <div style="font-size:14px;margin-top:2px;"><a href="${mailto}" style="color:#5aa0ff;text-decoration:none;">${e}</a></div>
        <div style="font-size:12px;color:#7d8aa8;margin-top:4px;">${when}</div>
      </td>
    </tr></table>
  </td></tr>
  <tr><td style="padding:16px 32px 0;">
    <div style="font-family:Orbitron,Arial,sans-serif;font-size:11px;letter-spacing:2px;color:#5aa0ff;text-transform:uppercase;">Subject</div>
    <div style="font-size:16px;font-weight:600;color:#ffffff;margin-top:6px;">${s}</div>
  </td></tr>
  <tr><td style="padding:20px 32px 8px;">
    <div style="background:#0d1424;border:1px solid #1e3a6e;border-left:4px solid #2F6BFF;border-radius:12px;padding:18px 20px;font-size:15px;line-height:1.65;color:#d7def0;">${m}</div>
  </td></tr>
  <tr><td align="center" style="padding:24px 32px 32px;">
    <a href="${mailto}" style="display:inline-block;background:#2F6BFF;background:linear-gradient(135deg,#2F6BFF,#00B4FF);color:#ffffff;font-family:Orbitron,Arial,sans-serif;font-size:14px;font-weight:700;letter-spacing:1px;text-decoration:none;padding:14px 32px;border-radius:30px;">Reply to ${n}</a>
  </td></tr>
  <tr><td style="border-top:1px solid #1e3a6e;padding:18px 32px;text-align:center;font-size:12px;color:#6b7896;">
    Sent from <a href="https://mohamedbenhmida-portfolio.web.app" style="color:#5aa0ff;text-decoration:none;">mohamedbenhmida-portfolio.web.app</a> · Mohamed Ben Hmida
  </td></tr>
</table>
</td></tr>
</table>
</body>
</html>`;
}

/** Sends through Brevo. Throws with Brevo's status on failure. */
export async function sendContactEmail(f: ContactForm, env: ContactEnv): Promise<void> {
  const res = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: { "api-key": env.BREVO_API_KEY, "content-type": "application/json", accept: "application/json" },
    body: JSON.stringify({
      sender: { name: "Portfolio · Mohamed Ben Hmida", email: env.SENDER_EMAIL },
      to: [{ email: env.CONTACT_TO, name: "Mohamed Ben Hmida" }],
      replyTo: { email: f.email, name: f.name },
      subject: `New message: ${f.subject || "Portfolio contact"}`,
      htmlContent: contactEmailHtml(f, new Date()),
      textContent: `From: ${f.name} <${f.email}>\nSubject: ${f.subject}\n\n${f.message}`,
    }),
  });
  if (!res.ok) throw new Error(`Brevo ${res.status}: ${await res.text()}`);
}
