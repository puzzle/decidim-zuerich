Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
    de: [
      {
        'question' => 'Nennen Sie eine Farbe des Zürcher Wappens.',
        'answers' => 'weiss,blau,Weiss,Blau'
      }
    ],
    en: [
      {
        'question' => 'Name a color on Zürich\'s flag',
        'answers' => 'white,blue,White,Blue'
      }
    ]
  }
end
