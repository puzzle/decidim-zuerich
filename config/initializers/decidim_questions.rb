Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
    de: [
      {
        'question' => 'Nenne eine Farbe des Zürcher Wappens.',
        'answers' => 'weiss,weiß,blau'
      },
      {
        'question' => 'Nenne eine Farbe, die auf dem Schweizer Wappen vorkommt.',
        'answers' => 'weiss,weiß,rot'
      },
      {
        'question' => 'Nenne die kleinste der folgenden Zahlen: 3 / 5 / 9.',
        'answers' => '3,drei'
      },
      {
        'question' => 'Was ergibt 2 plus 3?',
        'answers' => '5,fünf,fuenf,funf'
      }
    ],
    en: [
      {
        'question' => 'Name a color on Zürich\'s flag',
        'answers' => 'white,blue'
      },
      {
        'question' => 'Name one color of the Swiss flag.',
        'answers' => 'white,red'
      },
       {
        'question' => 'Name the smallest of the following numbers: 3 / 5 / 9.',
        'answers' => '3,three'
      },
       {
        'question' => 'What is 2 plus 3?',
        'answers' => '5,five'
      }      
    ]
  }
end
