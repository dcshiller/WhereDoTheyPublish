class JournalSeederJob
  @queue = :queue
  include Categories

  def self.perform
    set_journals
  end

  def self.set_journals
    journals = {
                  ap: ["Apeiron"],
                  as: ["Asian Philosophy", "Dao", "Journal of Chinese Philosophy"],
                  ae: ["Science and Engineering Ethics", "Neuroethics", "Educational Philosophy and Theory", "Environmental Ethics", "Journal of Law, Medicine, and Ethics", "Cambridge Quarterly of Healthcare Ethics", "Developing World Bioethics", "Bioethics", "American Journal of Bioethics", "Medicine and Philosophy", "Business Ethics Quarterly", "Journal of Business Ethics"],
                  em: ["Episteme%", "Erkenntnis", "Monist", "Synthese", "Analysis","Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Theory and Decision"],
                  et: ["%Ethics%", "Environmental Ethics", "Bioethics", "Journal of Philosophy", "Ethical Theory and Moral Practice", "Utiliats", "Ethics", "Journal of Ethics", "Journal of Ethics and Social Philosophy", "Theory and Decision"],
                  lo: ["Journal of Symbolic Logic", "Journal of Philosophical Logic", "Bulletin of Symbolic Logic"],
                  mp: ["Hume Studies", "British Journal for the History of Philosophy", "Journal of the History of Philosophy",  "New Nietzsche Studies", "Bulletin of the Hegel Society of Great Britain"],
                  mt: ["Monist", "Synthese", "Analysis", "Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics"],
                  pa: ["British Journal of Aesthetics", "Journal of Aesthetics and Art Criticism"],
                  pl: ["Linguistics and Philosophy", "Semiotica","Monist", "Synthese", "Analysis", "Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics", "%Language"],
                  po: ["Journal of Law, Medicine, and Ethics", "Political Theory", "Law and Philosophy", "Journal of Ethics and Social Philosophy"],
                  pm: ["Phenomenology and the Cognitive Sciences", "Neuroethics", "Consciousness and Cognition", "Behavioral and Brain Studies", "Mind%", "Journal of Consciousness Studies", "Review of Metaphysics"],
                  pr: ["Faith and Philosophy", "Religious Studies", "Ars Disputandi", "Augustinian Studies", "American Catholic Philosophical Quarterly"],
                  ps: ["Science and Engineering Ethics", "Hyle", "Journal for General Philosophy of Science", "Biology and Philosophy", "Brititsh Journal for the Philosophy of Science"]
              }
    journals.each do |category, names|
      names.each do |name|
        Journal.where("name LIKE '#{name}'").each do |jour|
          cats = jour.categorization
          cats[category] = 100
          jour.categorization = cats
          jour.save
        end
      end
    end
  end
end