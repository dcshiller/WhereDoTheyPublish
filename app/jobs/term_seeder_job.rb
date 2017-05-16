class TermSeederJob
  @queue = :queue
  include Categories

  def self.queue_all
    CATEGORIES.each do |cat, _|
      Resque.enqueue self, cat
    end
  end

  def self.perform(cat)
    set_terms(cat.to_sym)
  end

  def self.set_terms(cat)
    terms = {
              ap: %w[Plato Epicurus Akrasia Eleatic Eudaemonia Aristotle Stoic Socrates Lucretius Presocratic Greek Roman Augustine Boethius Classical Parmenides Empedocles],
              as: %w[Confucious Dao Nayaya Chinese Indian Buddhis Eastern],
              ae: %w[Corporation Love Obligation Trial Friend Queer Pornography Sex Euthanasia Abortion Doctor Patient Drug Death Life Health Disease Consent Market Libertarianism Exchange Capitalism Communism Price Regulation Sale Punishment],
              em: %w[ Ignorance Decision Disagreement Rationality Epistemolo Externalism Internalism Epistemic Evidence Belief Credence Knowledge Empiricism Foundationalism Coherentism Probability Likelihood Parsimony Perception Memory Sensitivity Gettier Skeptic Bayesianism ],
              et: %w[ Distributive Normative Motivation Egoism Wrongs Happiness Akratic Imperative Rawls Guilt Ought Killing Sidgwick Parfit Singer Externalism Internalism Friend Reason Akrasia Fair Evil Blame Life Deontic Moral Ethic Desert Consequentialism Value Rights Justice Good Wellbeing Punishment Obligation Obligatory Virtue Charity Utilitarianism Deontology],
              lo: %w[Axiom Computability Completeness Necessity Truth Logic S5 Modal S4],
              mp: %w[Descartes Hume Nietzsche Kierkegaard Hegel Modern Cartesian Bayle Aquinas Scholastic Thomastic Locke Spinoza Kant Wolff Leibniz Reid Occasionalism Transcedentalism],
              mt: %w[ Platon Aristotelian Humean Cartesian Event Ability Irrealism Disposition Proposition World Sorites Paradox Reality Truth Austere Correspondence Realism Antirealism Nominalism Externalism Trope Mereological Supervaluation Color Modal Explanation Parthood Metaphysics Presentism Objects Vagueness Time Space Fictionalism Physicalism Dualism Metaphysics Modality Existence Essence Grounding Necessity Abstract Number Naturalism],
              pa: %w[Aesthetics Art Film Poem Poetry Literature Beauty],
              pl: %w[Word Truth Content Proposition Frege Russell Lexical Name Determinism Vagueness Intensional Semantics Pragmatics Phonetic Sense Refer Guise Meaning Predicate Negation Implicature Sign Compositional Define Definition Concept Predicat],
              po: %w[Privacy Autonomy Paternalism Authority Libertarianism Freedom Guilt Innocence Government Trial Jury Society Law Democracy Consent Totalitarian Justice Citizen Civic Communism Vote Civil Tax Constructivism],
              pm: %w[ Preference Psycholog Motivation Happiness Seeing Properties Property Chalmers Searle Intention Will Agent Agency Freedom Knowledge Belief Memory Love Sensation Russell Intention Imagination Physicalism Dualism Consciousness Intentionality Perception Phenomenology Phenomenal Qualia Brain Cognitiv Seeing Rational Reason Emotion Concept],
              pr: %w[ Teleo God Thomastic Religious Mystic Thomism Aquinas Church Devout Religion Theo Faith Muslim Christian Heaven Hell Prayer Evil Divine Divinity Salvation Omniscience Omnipotence],
              ps: %w[Cell Cognitive Correlation Scientist Physics Relativity Atom Subatomic Animal Brain Neuron Science Genome Causation Physics Biology Evolution Quantum Chemistry]
            }
    terms[cat].each do |term|
      Publication.where("title LIKE '%#{term}%'").each do |pub|
        cats = pub.categorization
        cats[cat.to_s] = 100
        pub.categorization = cats
        pub.save
        print "."
      end
    end
  end
end