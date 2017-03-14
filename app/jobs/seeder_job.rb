class SeederJob
  @queue :queue

  def perform
    initial_settings
    set_terms
    set_journals
  end
  
  def initial_settings
    CATEGORIES = {
                    ap: "Ancient Philosophy",
                    as: "Asian Philosophy",
                    be: "Business Ethics",
                    cp: "Continental Philosophy",
                    cs: "Cognitive Science",
                    em: "Epistemology",
                    et: "Ethics",
                    ha: "History of Analytic",
                    lo: "Logic",
                    me: "Medical Ethics",
                    mt: "Metaphysics",
                    mp: "Modern Philosophy",
                    pa: "Aesthetics",
                    pl: "Philosophy of Language",
                    pm: "Philosphy of Mind",
                    po: "Political and Legal Philosophy",
                    pr: "Philosophy of Religion",
                    ps: "Philosophy of Science"
                  }

    average = CATEGORIES.keys.map { |k| [k, 5] }.to_h
    Journal.update_all(categorization: average)
    Author.update_all(categorization: average)
    Publication.update_all(categorization: average)
  end



  def set_terms
  terms = {
            ap: %w[Plato Aristotle Stoics Socrates Lucretius Greek Roman Augustine Boethius Classical],
            as: %w[Confucious Chinese Indian Buddhis Eastern],
            be: %w[Market Libertarianism Exchange Capitalism Communism Price Regulation Sale],
            cp: %w[Deconstruction Heiddeger Sartre Derrida Foucault Postmodern Camus Existential Constructivism Consent],
            cs: %w[Cognitive Brain Neuro Hippocampus],
            em: %w[Epistemic Evidence Belief Credence Knowledge Empiricism Coherentism Foundationalism Probability Bayesianism ],
            et: %w[Fair Deontic Moral Ethic Desert Consequentialism Value Rights Justice Good Wellbeing Obligation Charity Utilitarianism Deontology],
            fp: %w[Beauvoir Pornography Queer Feminist Disability Disabled Gender Race Lesbian Sex],
            ha: %w[Wittgenstein Russell Moore Frege],
            lo: %w[Axiom Computability Completeness Necessity Logic],
            me: %w[Euthanasia Abortion Doctor Patient Drug Death Life Health Disease Consent],
            mp: %w[Descartes Hume Locke Spinoza Kant Leibniz Reid Occasionalism Transcedentalism],
            mt: %w[Mereological Color Modal Explanation Parthood Metaphysics Presentism Objects Vagueness Time Space Nominalism Fictionalism Physicalism Dualism Metaphysics Modality Existence Essence Grounding Necessity Abstracta Number Naturalism],
            pa: %w[Aesthetics Art Literature Beauty],
            pl: %w[Lexical Name Determinism Vagueness Intensional Semantics Pragmatics Sense Reference Meaning Predicate Negation Implicature Sign Compositional Define Concept],
            po: %w[Autonomy Paternalism Authority Libertarianism Freedom Guilt Innocence Government Society Law Democracy Consent Totalitarian Justice Citizen Civic Communism Constructivism],
            pm: %w[Sensation Intention Imagination Physicalism Dualism Consciousness Intentionality Perception Phenomenology Qualia Brain Cognitivism Emotion Concept],
            pr: %w[God Christianity Divine Divinity Salvation Omniscience Omnipotence],
            ps: %w[Cell Correlation Science Genome Causation Physics Biology Evolution Quantum Chemistry]
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
  
  def set_journals
    journals = {
                  ap: ["Apeiron"],
                  as: ["Asian Philosophy", "Dao", "Journal of Chinese Philosophy"],
                  be: ["Business Ethics Quarterly", "Journal of Business Ethics"],
                  cp: ["Heiddeger Studies", "Continental Philosophy Review"],
                  cs: ["Review of Philosophy and Psychology", "Consciousness and Cognition", "Behavioral and Brain Sciences"],
                  em: ["Episteme%", "Synthese", "Analysis", "American Philosophical Quarterly", "Journal of Philosophy", "Analytic Philosophy", "Review of Metaphysics"],
                  et: ["Bioethics", "Journal of Philosophy", "Ethical Theory and Moral Practice", "Ethics", "Journal of Ethics"],
                  ha: ["Russel%"],
                  lo: ["Journal of Symbolic Logic", "Journal of Philosophical Logic", "Bulletin of Symbolic Logic"],
                  me: ["Journal of Law, Medicine, and Ethics", "Cambridge Quarterly of Healthcare Ethics", "Developing World Bioethics", "Bioethics", "American Journal of Bioethics", "Medicine and Philosophy"],
                  mp: ["Hume Studies", "British Journal for the History of Philosophy", "Bulletin of the Hegel Society of Great Britain"],
                  mt: ["Synthese", "Analysis", "Journal of Philosophy", "American Philosophical Quarterly", "Analytic Philosophy", "Review of Metaphysics"],
                  pa: ["British Journal of Aesthetics"],
                  pl: ["Linguistics and Philosophy", "Semiotica", "American Philosophical Quarterly", "Synthese", "Analysis", "Journal of Philosophy", "Analytic Philosophy", "Review of Metaphysics", "%Language"],
                  po: ["Journal of Law, Medicine, and Ethics", "Political Theory", "Law and Philosophy"],
                  pm: ["Consciousness and Cognition", "Behavioral and Brain Studies", "Mind%", "Journal of Consciousness Studies"],
                  pr: ["Faith and Philosophy", "Religious Studies", "Ars Disputandi", "Augustinian Studies", "American Catholic Philosophical Quarterly"],
                  ps: ["Journal for General Philosophy of Science", "Biology and Philosophy", "Brititsh Journal for the Philosophy of Science"]
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