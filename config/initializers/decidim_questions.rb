Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
    de: [
      {
        'question' => 'Nennen Sie eine der beiden Farben des Wappens der Stadt Zürich.',
        'answers' => 'weiss,blau,Weiss,Blau'
      }
    ],
    en: [
      {
        'question' => 'Name one of the two colors of the city of Zurich coat of arms.',
        'answers' => 'white,blue,White,Blue'
      }
    ]
  }
end
