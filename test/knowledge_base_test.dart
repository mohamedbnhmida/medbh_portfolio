import 'package:flutter_test/flutter_test.dart';
import 'package:medbh_portfolio/chatbot/knowledge_base.dart';

void main() {
  test('ready answers match the expected topic', () {
    expect(KnowledgeBase.answer('How many years of experience do you have?'), contains('5+ years'));
    expect(KnowledgeBase.answer('Do you work on VoIP SDKs?'), contains('VoIP'));
    expect(KnowledgeBase.answer('do you have an idea about fintech project?'), contains('two large banking apps'));
    expect(KnowledgeBase.answer('Are you available to hire?'), contains('open to'));
    expect(KnowledgeBase.answer('Tell me about Seekers'), contains('outdoor adventure'));
    expect(KnowledgeBase.answer('which architecture do you use?'), contains('MVVM'));
    expect(KnowledgeBase.answer('what is this'), isNull); // "hi" must not match inside "this"
  });
}
