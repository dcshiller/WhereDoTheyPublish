module ApplicationHelper
  def category_name
    {
      pl: "Philosophy of Language",
      pm: "Philosphy of Mind",
      mt: "Metaphysics",
      em: "Epistemology",
      cs: "Cognitive Science",
      lo: "Logic",
      ps: "Philosophy of Science",
      pb: "Philosophy of Biology",
      et: "Ethics",
      fo: "Formal Philosophy",
      po: "Political Philosophy",
      lp: "Philosophy of Law",
      me: "Medical Ethics",
      fp: "Feminist Philosophy",
      pa: "Aesthetics",
      ap: "Ancient Philosophy",
      as: "Asian Philosophy",
      mp: "Modern Philosophy",
      ha: "History of Analytic",
      pr: "Philosophy of Religion",
      cp: "Continental Philosophy",
      be: "Business Ethics"
    }.with_indifferent_access
  end
end