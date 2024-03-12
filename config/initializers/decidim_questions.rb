Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
    de: [
      {
        'question' => 'Nenne eine Farbe des Zürcher Wappens.',
        'answers' => 'weiss,Weiss,WEISS,blau,Blau,BLAU'
      },
      {
        'question' => 'Nenne eine Farbe, die auf dem Schweizer Wappen vorkommt.',
        'answers' => 'weiss,Weiss,WEISS,rot,Rot,ROT'
      },
      {
        'question' => 'Nenne die kleinste der folgenden Zahlen: 3 / 5 / 9.',
        'answers' => '3,drei,Drei,DREI'
      },
      {
        'question' => 'Was ergibt 2 plus 3?',
        'answers' => '5,fünf,FÜNF,fuenf,FUENF'
      }
    ],
    en: [
      {
        'question' => 'Name a color on Zürich\'s flag',
        'answers' => 'white,White,WHITE,blue,Blue,BLUE'
      },
      {
        'question' => 'Name one color of the Swiss flag.',
        'answers' => 'white,White,WHITE,red,Red,RED'
      },
       {
        'question' => 'Name the smallest of the following numbers: 3 / 5 / 9.',
        'answers' => '3,three,Three,THREE'
      },
       {
        'question' => 'What is 2 plus 3?',
        'answers' => '5,five,Five,FIVE'
      }      
    ]
  }
end
