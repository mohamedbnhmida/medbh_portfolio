/// The portfolio's Cloudflare Worker (source in chat_worker/): chatbot answers and
/// contact-form email. It holds the API keys; the website never does.
class WorkerApi {
  static const baseUrl =
      'https://portfolio-chat.portfolio-chat-worker.workers.dev';
}
