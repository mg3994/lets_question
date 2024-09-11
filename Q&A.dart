////////////////<br>
///
///Question
///
////////////////
sealed class Question {
  const Question();

  static Question fromMap(Map<String, dynamic> json) => switch (json) {
        {
          'type': 'textQuestion',
          'category': String category,
          'answer': Map<String, dynamic> answer,
          'questionBody': String body,
          'id': String id,
        } =>
          TextQuestion(
              questionBody: body,
              category: category,
              answer: Answer.fromMap(answer),
              id: id),
        {
          'type': 'imageQuestion',
          'category': String category,
          'answer': Map<String, dynamic> answer,
          'imagePath': String imagePath, //either body or image path
          'id': String id,
        } =>
          ImageQuestion(
            imagePath: imagePath,
            category: category,
            answer: Answer.fromMap(answer),
            id: id,
          ),
        _ => throw FormatException("neither Text Question Nor Image Question")
      };
}

final class TextQuestion extends Question {
  const TextQuestion(
      {required this.questionBody,
      required this.category,
      required this.answer,
      required this.id});
  final String questionBody;
  final String category;
  final Answer answer;
  final String id;
}

final class ImageQuestion extends Question {
  const ImageQuestion(
      {required this.imagePath,
      required this.category,
      required this.answer,
      required this.id});
  final String imagePath;
  final String category;
  final Answer answer;
  final String id;
}

////////////////<br>
///
///Answer
///
////////////////
sealed class Answer {
  const Answer();
  static Answer fromMap(Map<String, dynamic> json) => switch (json) {
        {
          'type': 'openTextAnswer',
          'correctAnswer': String correctAnswer,
        } =>
          OpenTextAnswer(correctAnswer: correctAnswer),
        {
          'type': 'multipleChoiceAnswer',
          'correctAnswer': String correctAnswer,
          'answerOptions': List<dynamic> answerOptions,
        } =>
          MultipleChoiceAnswer(
              //only single choice here
              correctAnswer: correctAnswer,
              answerOptions: answerOptions.cast<String>()),
        {
          'type': 'booleanAnswer',
          'correctAnswer': String correctAnswer,
        } =>
          BooleanAnswer(correctAnswer: correctAnswer),
        _ => throw FormatException("Answer Format Not Matched With Any of ....")
      };
}

/// here we have true and false
final class BooleanAnswer extends Answer {
  const BooleanAnswer({required this.correctAnswer});
  final String correctAnswer;
}

/// here we have to choose one answer from MultipleChoices
final class MultipleChoiceAnswer extends Answer {
  const MultipleChoiceAnswer(
      {required this.correctAnswer, required this.answerOptions});
  final String correctAnswer;
  final List<String> answerOptions;
}

final class OpenTextAnswer extends Answer {
  const OpenTextAnswer({required this.correctAnswer});
  final String correctAnswer;
}

////////////////<br>
///
///Widget Maker
///
////////////////
(QuestionWidget, AnswerWidget) questionAndAnswerView(Question question) {
  return switch (question) {
    // TODO: Handle all case.
    TextQuestion(:MultipleChoiceAnswer answer) => (
        TextQuestionWidget(question: question),
        MultipleChoiceWidget(answer: answer)
      ),
    // TODO: Handle all case.
    TextQuestion(:OpenTextAnswer answer) => (
        TextQuestionWidget(question: question),
        TextAnswerWidget(answer: answer)
      ),
    // TODO: Handle all case.
    TextQuestion(:BooleanAnswer answer) => (
        TextQuestionWidget(question: question),
        BooleanAnswerWidget(answer: answer)
      ),
    // TODO: Handle all case.
    ImageQuestion(:MultipleChoiceAnswer answer) => (
        ImageQuestionWidget(question: question),
        MultipleChoiceWidget(answer: answer)
      ),
    // TODO: Handle all case.
    ImageQuestion(:OpenTextAnswer answer) => (
        ImageQuestionWidget(question: question),
        TextAnswerWidget(answer: answer)
      ),
    // TODO: Handle all case.
    ImageQuestion(:BooleanAnswer answer) => (
        ImageQuestionWidget(question: question),
        BooleanAnswerWidget(answer: answer) //here we have true and false
      ),
  };
}
