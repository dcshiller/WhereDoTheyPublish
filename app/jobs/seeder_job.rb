class SeederJob
  @queue = :queue
  CATEGORIES = {
                  ap: "Ancient Philosophy",
                  as: "Asian Philosophy",
                  ae: "Applied Ethics",
                  em: "Epistemology",
                  et: "Ethics",
                  lo: "Logic",
                  mt: "Metaphysics",
                  mp: "Modern Philosophy",
                  pa: "Aesthetics",
                  pl: "Philosophy of Language",
                  pm: "Philosphy of Mind",
                  po: "Political and Legal Philosophy",
                  pr: "Philosophy of Religion",
                  ps: "Philosophy of Science"
                }

  def self.perform
    initial_settings
    set_terms
    set_journals
  end
  
  def self.initial_settings
    average = CATEGORIES.keys.map { |k| [k, 5] }.to_h
    Journal.update_all(categorization: average)
    Author.update_all(categorization: average)
    Publication.update_all(categorization: average)
  end

  def self.set_terms
    terms = {
              ap: %w[Plato Epicurus Akrasia Eleatic Eudaemonia Aristotle Stoic Socrates Lucretius Presocratic Greek Roman Augustine Boethius Classical],
              as: %w[Confucious Dao Nayaya Chinese Indian Buddhis Eastern],
              ae: %w[Corporation Love Obligation Trial Friend Queer Pornography Sex Euthanasia Abortion Doctor Patient Drug Death Life Health Disease Consent Market Libertarianism Exchange Capitalism Communism Price Regulation Sale Punishment],
              em: %w[Epistemolo Argument Externalism Internalism Epistemic Evidence Belief Credence Knowledge Empiricism Foundationalism Coherentism Foundationalism Probability Likelihood Parsimony Perception Memory Sensitivity Gettier Skeptic Bayesianism ],
              et: %w[Normative Motivation Egoism Wrongs Happiness Akratic Imperative Rawls Guilt Ought Killing Sidgwick Parfit Singer Externalism Internalism Love Friend Reason Akrasia Fair Evil Blame Life Deontic Moral Ethic Desert Consequentialism Value Rights Justice Good Wellbeing Punishment Obligation Obligatory Virtue Charity Utilitarianism Deontology],
              lo: %w[Axiom Computability Completeness Necessity Truth Logic S5 Modal S4],
              mp: %w[Descartes Hume Nietzsche Kierkegaard Hegel Modern Cartesian Bayle Aquinas Scholastic Thomastic Locke Spinoza Kant Wolff Leibniz Reid Occasionalism Transcedentalism],
              mt: %w[Platon Aristotelian Humean Cartesian Event Ability Irrealism Disposition Proposition World Sorites Paradox Reality Truthmaker Correspondence Realism Antirealism Nominalism Externalism Trope Mereological Supervaluation Color Modal Explanation Parthood Metaphysics Presentism Objects Vagueness Time Space Fictionalism Physicalism Dualism Metaphysics Modality Existence Essence Grounding Necessity Abstract Number Naturalism],
              pa: %w[Aesthetics Art Film Poem Poetry Literature Beauty],
              pl: %w[Word Truth Content Proposition Frege Russell Lexical Name Determinism Vagueness Intensional Semantics Pragmatics Phonetic Sense Refer Guise Meaning Predicate Negation Implicature Sign Compositional Define Definition Concept],
              po: %w[Privacy Autonomy Paternalism Authority Libertarianism Freedom Guilt Innocence Government Trial Jury Society Law Democracy Consent Totalitarian Justice Citizen Civic Communism Vote Civil Tax Constructivism],
              pm: %w[Motivation Happiness Seeing Properties Property Chalmers Searle Intention Will Agent Agency Freedom Knowledge Belief Memory Love Sensation Russell Intention Imagination Physicalism Dualism Consciousness Intentionality Perception Phenomenology Phenomenal Qualia Brain Cognitiv Seeing Rational Reason Emotion Concept],
              pr: %w[God Thomastic Religious Mystic Thomism Aquinas Church Devout Religion Theo Faith Muslim Christian Heaven Hell Prayer Evil Divine Divinity Salvation Omniscience Omnipotence],
              ps: %w[Cell Cognitive Correlation Scientist Physics Relativity Atom Subatomic Animal Brain Neuron Science Genome Causation Physics Biology Evolution Quantum Chemistry]
            }
    terms.each do |category, cat_terms|
      cat_terms.each do |term|
        Publication.where("title LIKE '%#{term}%'").each do |pub|
          cats = pub.categorization
          cats[category] = 100
          pub.categorization = cats
          pub.save
          print "."
        end
      end
    end
  end

  def self.set_journals
    journals = {
                  ap: ["Apeiron"],
                  as: ["Asian Philosophy", "Dao", "Journal of Chinese Philosophy"],
                  ae: ["Science and Engineering Ethics", "Neuroethics", "Educational Philosophy and Theory", "Environmental Ethics", "Journal of Law, Medicine, and Ethics", "Cambridge Quarterly of Healthcare Ethics", "Developing World Bioethics", "Bioethics", "American Journal of Bioethics", "Medicine and Philosophy", "Business Ethics Quarterly", "Journal of Business Ethics"],
                  em: ["Episteme%", "Erkenntnis", "Monist", "Synthese", "Analysis","Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics", "Theory and Decision"],
                  et: ["%Ethics%", "Environmental Ethics", "Bioethics", "Journal of Philosophy", "Ethical Theory and Moral Practice", "Utiliats", "Ethics", "Journal of Ethics", "Journal of Ethics and Social Philosophy", "Theory and Decision"],
                  lo: ["Journal of Symbolic Logic", "Journal of Philosophical Logic", "Bulletin of Symbolic Logic"],
                  mp: ["Hume Studies", "British Journal for the History of Philosophy", "Journal of the History of Philosophy",  "New Nietzsche Studies", "Bulletin of the Hegel Society of Great Britain"],
                  mt: ["Monist", "Synthese", "Analysis", "Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics"],
                  pa: ["British Journal of Aesthetics", "Journal of Aesthetics and Art Criticism"],
                  pl: ["Linguistics and Philosophy", "Semiotica","Monist", "Synthese", "Analysis", "Thought", "Dialectica", "Journal of Philosophy", "Philosophical Review", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics", "%Language"],
                  po: ["Journal of Law, Medicine, and Ethics", "Political Theory", "Law and Philosophy", "Journal of Ethics and Social Philosophy"],
                  pm: ["Phenomenology and the Cognitive Sciences", "Neuroethics", "Consciousness and Cognition", "Behavioral and Brain Studies", "Mind%", "Journal of Consciousness Studies"],
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