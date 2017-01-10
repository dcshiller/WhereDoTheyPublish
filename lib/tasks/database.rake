namespace :db do
  desc "download query"
  task :query, [:author1] => :environment do |t, args|
    authors = [args[:author1]]
    authors.each do |author|
      # author = Author.new(first_name: "Derek", last_name: "Shiller")
      q = Query.new([author], 'philosophy', 1)
      start_count = Publication.count
      cr = CrossRefDispatcher.new(q)
      cr.dispatch
      pubs = cr.response
      PubSaver.save(pubs)
      puts "#{author} (+ #{Publication.count - start_count})"
      sleep 3
    end
  end

  task condense: :environment do 
    Journal.find_each do |j|
      j.condensed_name = Journal.condensed_name(j.name)
      j.save
    end
  end
  
  task :query_all_authors, [:start] => :environment do |t, args|
    authors = "Germain Grisez
      Adolf Grünbaum
      Félix Guattari
      Gotthard Günther
      Samuel Guttenplan
      Paul Guyer
      Kwame Gyekye
      Susan Haack
      Jürgen Habermas
      Peter Hacker
      Ian Hacking
      Manly Palmer Hall
      Philip Hallie
      Stuart Hampshire
      Alastair Hannay
      Norwood Russell Hanson
      Donna Haraway
      Michael Hardt
      John E. Hare
      R. M. Hare
      Gilbert Harman
      Errol Harris
      H. L. A. Hart
      David Bentley Hart
      Sally Haslanger
      John Haugeland
      John Hawthorne
      Werner Heisenberg
      Ágnes Heller
      Erich Heller
      Futa Helu
      Carl Gustav Hempel
      Michel Henry
      Abraham Joshua Heschel
      Mary Hesse
      John Hick
      Stephen Hicks
      Alice von Hildebrand
      Jaakko Hintikka
      Ted Honderich
      Sidney Hook
      Jennifer Hornsby
      Paul Horwich
      John Hospers
      Paulin J. Hountondji
      Rosalind Hursthouse
      Robert Maynard Hutchins
      Hsu Fu-kuan
      Jean Hyppolite
      Don Ihde
      Evald Vassilievich Ilyenkov
      Peter van Inwagen
      Luce Irigaray
      Terence Irwin
      Frank Jackson
      Fredric Jameson
      Christopher Janaway
      Erich Jantsch
      Richard C. Jeffrey
      Hans Jonas
      Shelly Kagan
      Robert Kane
      Jerrold Katz
      Walter Kaufmann
      David Kaplan
      David Kelley
      Anthony Kenny
      Mahmoud Khatami
      Jaegwon Kim
      Mark Kingwell
      Robert Kirk
      Richard Kirkham
      Philip Kitcher
      Martha Klein
      Peter D. Klein
      Brian Klug
      William Calvert Kneale
      Hans Köchler
      Arthur Koestler
      Alexandre Kojève
      John Kok
      Leszek Kolakowski
      Hilary Kornblith
      Stephan Körner
      Christine Korsgaard
      Peter Kreeft
      Georg Kreisel
      Saul Kripke
      Julia Kristeva
      Irving Kristol
      Erik von Kuehnelt-Leddihn
      Thomas Samuel Kuhn
      Will Kymlicka
      Jacques Lacan
      Philippe Lacoue-Labarthe
      Imre Lakatos
      Michèle Le Dœuff
      Henri Lefebvre
      Keith Lehrer
      Yeshayahu Leibowitz
      Brian Leiter
      James G. Lennox
      Ernest Lepore
      Isaac Levi
      Emmanuel Levinas
      Claude Lévi-Strauss
      Bernard-Henri Lévy
      David Kellogg Lewis
      Suzanne Lilar
      Alphonso Lingis
      Gilles Lipovetsky
      Arthur Lipsett
      Knud Ejler Løgstrup
      Bernard Lonergan
      Paul Lorenzen
      Roderick T. Long
      John R. Lucas
      Peter Ludlow
      William Lycan
      Jean-François Lyotard
      Dwight Macdonald
      Tibor R. Machan
      Alasdair MacIntyre
      Louis Mackey
      John Leslie Mackie
      Penelope Maddy
      Norman Malcolm
      David Malament
      Mostafa Malekian
      Merab Mamardashvili
      Jon Mandle
      Claude Mangion
      Ruth Barcan Marcus
      Julián Marías
      Donald A. Martin
      Michael Martin
      Abul A'la Maududi
      George I. Mavrodes
      Ron McClamrock
      John McDowell
      Colin McGinn
      Terence McKenna
      Marshall McLuhan
      Jeff McMahan
      John McMurtry
      Alfred Mele
      David Hugh Mellor
      Eduardo Mendieta
      Maurice Merleau-Ponty
      Thomas Metzinger
      Vincent Miceli
      Mary Midgley
      Alan Millar
      Fred Miller
      Ruth Millikan
      C. Wright Mills
      Richard Montague
      Max More
      J. P. Moreland
      Sidney Morgenbesser
      Adam Morton
      Mou Zongsan
      Iris Murdoch
      Mwalimu Julius Kambarage Nyerere
      Arne Næss
      Ernest Nagel
      Thomas Nagel
      Jean-Luc Nancy
      Jan Narveson
      Hossein Nasr(born 1933)
      Stephen Neale(born 1958)
      Antonio Negri
      Oskar Negt(born 1934)
      Alexander Nehamas
      John von Neumann
      Jay Newman
      Kai Nielsen
      Nishitani Keiji
      Kwame Nkrumah
      Nel Noddings
      Ernst Nolte
      Calvin Normore
      Christopher Norris
      David L. Norton
      Robert Nozick
      Martha Nussbaum
      Anthony O'Hear
      Onora O'Neill
      Michael Oakeshott
      Albert Outler
      Gwilyn Ellis Lane Owen
      David Papineau
      Derek Parfit
      John Arthur Passmore
      Jan Patočka
      Christopher Peacocke
      David Pearce
      David Pears
      Jean-Jacques Pelletier
      Leonard Peikoff
      Lorenzo Peña
      Richard Stanley Peters
      Philip Pettit
      Gualtiero Piccinini
      Herman Philipse
      D. Z. Phillips
      Giovanni Piana
      Alexander Piatigorsky
      Robert M. Pirsig
      Alvin Plantinga
      Thomas Pogge
      Louis P. Pojman
      Leonardo Polo
      Richard Popkin
      K. J. Popma
      Karl Popper
      Dag Prawitz
      Graham Priest
      Arthur Prior
      Harry Prosch
      Hilary Putnam
      Andrew Pyle
      Qiu Renzong
      Willard Van Orman Quine
      Anthony Quinton
      Sayyid Qutb
      James Rachels
      Ayn Rand
      Karl Rahner
      Peter Railton
      Tariq Ramadan
      Frank P. Ramsey*
      Ian Thomas Ramsey
      Paul Ramsey
      Jacques Rancière
      Douglas B. Rasmussen
      John Rawls
      Joseph Raz
      George Reisman
      Nicholas Rescher
      Janet Radcliffe Richards
      Radovan Richta
      Paul Ricoeur
      R. R. Rockingham Gill
      Avital Ronell
      Richard Rorty
      Gillian Rose
      Alexander Rosenberg
      Gian-Carlo Rota
      Joseph Rovan
      William L. Rowe
      Michael Ruse
      Gilbert Ryle
      Robert Rynasiewicz
      Mark Sainsbury
      Nathan Salmon
      Wesley Salmon
      Michael J. Sandel
      David H. Sanford
      Prabhat Rainjan Sarkar
      Jean-Paul Sartre
      Crispin Sartwell
      John Ralston Saul
      Fernando Savater
      Thomas Scanlon
      Richard Schacht
      Francis Schaeffer
      Stephen Schiffer
      Hubert Schleichert
      J. B. Schneewind
      Frithjof Schuon
      Roger Scruton
      John Searle
      Wilfrid Sellars
      Amartya Sen
      Michel Serres
      Neven Sesardić
      Stanley Sfekas
      Stewart Shapiro
      Dariush Shayegan
      Abner Shimony
      Sydney Shoemaker
      Richard Shusterman
      Peter Singer
      B. F. Skinner
      John Skorupski
      Brian Skyrms
      Michael Slote
      Peter Sloterdijk
      J. J. C. Smart
      Huston Smith
      Michael A. Smith
      Tara Smith
      Raymond Smullyan
      Joseph D. Sneed
      Scott Soames
      Elliott Sober
      Alan Soble
      Robert C. Solomon
      Joseph Soloveitchik
      Richard Sorabji
      Abdolkarim Soroush
      David Sosa
      Ernest Sosa
      Thomas Sowell
      David Spangler
      Herbert Spiegelberg
      Gayatri Chakravorty Spivak
      Timothy Sprigge
      Edward Stachura
      Robert Stalnaker
      Jason Stanley
      Charles Leslie Stevenson
      Stephen Stich
      Bernard Stiegler
      Dejan Stojanović
      Jeffrey Stout
      David Stove
      Galen Strawson
      P. F. Strawson
      Gisela Striker
      Barry Stroud
      Patrick Suppes
      Richard Swinburne
      David Sztybel
      Javad Tabatabai
      Nassim Nicholas Taleb
      Robert B. Talisse
      Tang Junyi
      Alfred Tarski
      Charles Taylor
      Richard Taylor
      Placide Tempels
      Neil Tennant
      Irving Thalberg Jr.
      Helmut Thielicke
      Judith Jarvis Thomson
      Tzvetan Todorov
      Stephen Toulmin
      Peter Tudvad
      Ernst Tugendhat
      Raimo Tuomela
      Alan Turing
      Peter Unger
      Ivo Urbančič
      Alasdair Urquhart
      Bas van Fraassen
      Peter van Inwagen
      Philippe Van Parijs
      Francisco Varela
      Juha Varto
      Gianni Vattimo
      Achille Varzi
      Adolfo Sánchez Vázquez
      Henry Babcock Veatch
      Michel Villey
      Gregory Vlastos
      Eric Voegelin
      Jules Vuillemin
      Georg Henrik von Wright
      Margaret Urban Walker
      Doug Walton
      Kendall Walton
      Michael Walzer
      Ernest Wamba dia Wamba
      Hao Wang
      Georgia Warnke
      Geoffrey J. Warnock
      Mary Warnock
      Alan Watts
      Brian Weatherson
      Simone Weil
      Morris Weitz
      Carl Friedrich von Weizsäcker
      Albrecht Wellmer
      Cornel West
      Jennifer Whiting
      David Wiggins
      John Daniel Wild
      Dallas Willard
      Bernard Williams
      Timothy Williamson
      Jessica Wilson
      Margaret Dauler Wilson
      Peter Winch
      Kwasi Wiredu
      John Wisdom
      Charlotte Witt
      Monique Wittig
      Susan R. Wolf
      Ursula Wolf
      Richard Wollheim
      Nicholas Wolterstorff
      Paul Woodruff
      Crispin Wright
      Jerzy Wróblewski
      Alison Wylie
      Xu Liangying
      Cemal Yıldırım
      Francis Parker Yockey
      Arthur M. Young
      Damon Young
      Iris Marion Young
      Jiyuan Yu
      Santiago Zabala
      Naomi Zack
      Linda Trinkaus Zagzebski
      Dan Zahavi
      José Zalabardo
      Edward N. Zalta
      Marlène Zarader
      Ingo Zechner
      Eddy Zemach
      John Zerzan
      Yujian Zheng
      Zhai Zhenming
      Zhou Guoping
      Paul Ziff
      Robert Zimmer
      Dean Zimmerman
      Michael E. Zimmerman
      Alexander Zinoviev
      Slavoj Žižek
      Elémire Zolla
      Volker Zotz
      François Zourabichvili
      Estanislao Zuleta
      Alenka Zupančič
      Jan Zwicky
    ".split("\n")
    # Author.all.collect(&:name)
    authors.each do |author|
      q = Query.new([author], 'philosophy', 1)
      start_count = Publication.count
      cr = CrossRefDispatcher.new(q)
      cr.dispatch
      pubs = cr.response
      PubSaver.save(pubs)
      puts "#{author} (+ #{Publication.count - start_count})"
      sleep 5
    end
  end
  
  task :add_names, [:start] => :environment do |t, args|
      # Elisa Aaltola
      # Nicola Abbagnano
      # Bijan Abdolkarimi
      # Taha Abdurrahman
      # David Abram
      # Gerd B. Achenbach
      # Peter Achinstein
      # Hans Achterhuis
      # H. B. Acton
      # Marilyn McCord Adams
      # Robert Merrihew Adams
      # Mortimer Adler
      # Theodor Adorno
      # Sediq Afghan
      # Michel Aflaq
      # Giorgio Agamben
      # Hans Albert
      # Rogers Albritton
      # Virgil Aldrich
      # Gerda Alexander
      # Aleksandr Danilovich Aleksandrov
      # Robert Alexy
      # Diogenes Allen
      # William Alston
      # Louis Althusser
      # Günther Anders
      # Alan Ross Anderson
      # C. Anthony Anderson
      # Pamela Sue Anderson
      # G. E. M. Anscombe
      # Karl-Otto Apel
      # Kwame Anthony Appiah
      # Hannah Arendt
      # David Malet Armstrong
      # Zaki al-Arsuzi
      # Raymond Aron
      # Pandurang Shastri Athavale
      # Robert Audi
      # John Langshaw Austin
      # Alfred Jules Ayer
      # Joxe Azurmendi
      # Kent Bach
      # Alain Badiou
      # Archie J. Bahm
      # Annette Baier
      # Kurt Baier
      # Albena Bakratcheva
      # Tom Baldwin
      # Étienne Balibar
      # Hassan al-Banna
      # Yehoshua Bar-Hillel
      # Jonathan Barnes
      # Brian Barry
      # Norman P. Barry
      # William Barrett
      # Roland Barthes
      # Jon Barwise
      # Jacques Barzun
      # Jean Baudrillard
      # Monroe Beardsley
      # Jean Beaufret
      # William Bechtel
      # Lewis White Beck
      # Francis J. Beckwith
      # Nuel Belnap
      # Paul Benacerraf
      # Jonathan Bennett
      # Geoffrey Bennington
      # Frithjof Bergmann
      # Gustav Bergmann
      # Isaiah Berlin
      # Marshall Berman
      # Robert Bernasconi
      # Alfred Bernhart
      # Andrew Bernstein
      # Richard Bett
      # Jean-Yves Béziau
      # Homi K. Bhabha
      # Roy Bhaskar
      # Harry Binswanger
      # Max Black
      # Simon Blackburn
      # Maurice Blanchot
      # David Blitz
      # Ned Block
      # Allan Bloom
      # Norberto Bobbio
      # Jozef Maria Bochenski
      # Paul Boghossian
      # Hilary Bok
      # Sissela Bok
      # Dietrich Bonhoeffer
      # Laurence BonJour
      # George Boolos
      # Nick Bostrom
      # Pierre Bourdieu
      # Richard-Bevan Braithwaite
      # Myles Brand
      # Robert Brandom
      # Richard B. Brandt
      # Michael Bratman
      # Stephen E. Braude
      # Harry Brighouse
      # Berit Brogaard
      # Stephen Bronner
      # John Broome
      # Pascal Bruckner
      # Mario Bunge
      # Tyler Burge
      # John Burnheim
      # Myles Burnyeat
      # Panayot Butchvarov
      # Judith Butler
      # Charles Butterworth
      # Amílcar Cabral
      # John Campbell
      # Albert Camus
      # Georges Canguilhem
      # John D. Caputo
      # Nancy Cartwright
      # Quassim Cassam
      # Hector-Neri Castañeda
      # David Castle
      # Cornelius Castoriadis
      # Paola Cavalieri
      # Stanley Cavell
      # Michel de Certeau
      # David Chalmers
      # Timothy Chambers
      # David Charles
      # Haridas Chaudhuri
      # Albert Chernenko
      # Noam Chomsky
      # Alonzo Church
      # Patricia Churchland
      # Paul Churchland
      # Frank Cioffi
      # Hélène Cixous
      # Andy Clark
      # Stephen R. L. Clark
      # David Cockburn
      # Gerald Cohen
      # L. Jonathan Cohen
      # Lucio Colletti
      # Robin Collins
      # André Comte-Sponville
      # Marcel Conche
      # Frederick Copleston
      # Jack Copeland
      # William Lane Craig
      # Jean Curthoys
      # Newton da Costa
      # Mary Daly
      # Jonathan Dancy
      # Arthur Danto
      # Donald Davidson
      # Brian Davies
      # Michael Davis
      # Simone de Beauvoir
      # Alain de Benoist
      # Alain de Botton
      # Bruno de Finetti
      # Paul de Man
      # Guy Debord
      # Gilles Deleuze
      # Bernard Delfgaauw
      # Daniel Dennett
      # Douglas Den Uyl
      # Jacques Derrida
      # Vincent Descombes
      # Sousa Dias
      # Daniel Dombrowski
      # Keith Donnellan
      # Fred Dretske
      # Hubert Dreyfus
      # Michael Dummett
      # Ronald Dworkin
      # Miroslaw Dzielski
      # William A. Earle
      # John Earman
      # Umberto Eco
      # Dorothy Edgington
      # James M. Edie
      # Paul Edwards
      # Mircea Eliade
      # Ignacio Ellacuria
      # Jacques Ellul
      # Jon Elster
      # John Etchemendy
      # Gareth Evans
      # Stanley Eveling
      # Emmanuel Chukwudi Eze
      # Emil Fackenheim
      # Frantz Fanon
      # Austin Marsden Farrer
      # Solomon Feferman
      # Herbert Feigl
      # Joel Feinberg
      # José Ferrater Mora
      # Roderick Chisholm
      # Hartry Field
      # Arthur Fine
      # Kit Fine
      # John Finnis
      # Owen Flanagan
      # Richard E. Flathman
      # Antony Flew
      # Luciano Floridi
      # Vilém Flusser
      # Jerry Fodor
      # Dagfinn Føllesdal
      # Philippa Foot
      # Michel Foucault
      # Bas van Fraassen
      # William K. Frankena
      # Harry Frankfurt
      # Oliver Shewell Franks
      # Michael Frede
      # Hans Wilhelm Frei
      # Erich Fromm
      # Northrop Frye
      # Lon L. Fuller
      # Hans-Georg Gadamer
      # Raimond Gaita
      # David Gauthier
      # Peter Geach
      # Ernest Gellner
      # Gerhard Gentzen
      # Alexander George
      # Bernard Gert
      # Edmund Gettier
      # Raymond Geuss
      # Alan Gewirth
      # Rashid al-Ghannushi
      # Allan Gibbard
      # Margaret Gilbert
      # Neil Gillman
      # René Girard
      # Ernst von Glasersfeld
      # Jonathan Glover
      # Kurt Gödel
      # Peter Goldie
      # Alvin Goldman
      # Lucien Goldmann
      # Jacob Golomb
      # Nicolás Gómez Dávila
      # Nelson Goodman
      # Paul Goodman
      # Allan Gotthelf
      # George Grant
      # John Gray
      # A. C. Grayling
      # Celia Green
      # Herbert Paul Grice
      # Germain Grisez
      # Adolf Grünbaum
      # Félix Guattari
      # Gotthard Günther
      # Samuel Guttenplan
      # Paul Guyer
      # Kwame Gyekye
      # Susan Haack
      # Jürgen Habermas
      # Peter Hacker
      # Ian Hacking
      # Manly Palmer Hall
      # Philip Hallie
      # Stuart Hampshire
      # Alastair Hannay
      # Norwood Russell Hanson
      # Donna Haraway
      # Michael Hardt
      # John E. Hare
      # R. M. Hare
      # Gilbert Harman
      # Errol Harris
      # H. L. A. Hart
      # Paul Feyerabend
      # David Bentley Hart
      # Sally Haslanger
      # John Haugeland
      # John Hawthorne
      # Werner Heisenberg
      # Ágnes Heller
      # Erich Heller
      # Futa Helu
      # Carl Gustav Hempel
      # Michel Henry
      # Abraham Joshua Heschel
      # Mary Hesse
      # John Hick
      # Stephen Hicks
      # Alice von Hildebrand
      # Jaakko Hintikka
      # Ted Honderich
      # Sidney Hook
      # Jennifer Hornsby
      # Paul Horwich
      # John Hospers
      # Paulin J. Hountondji
      # Rosalind Hursthouse
      # Robert Maynard Hutchins
      # Hsu Fu-kuan
      # Jean Hyppolite
      # Don Ihde
      # Evald Vassilievich Ilyenkov
      # Peter van Inwagen
      # Luce Irigaray
      # Terence Irwin
      # Frank Jackson
      # Fredric Jameson
      # Christopher Janaway
      # Erich Jantsch
      # Richard C. Jeffrey
      # Hans Jonas
      # Shelly Kagan
      # Robert Kane
      # Jerrold Katz
      # Walter Kaufmann
      # David Kaplan
      # David Kelley
      # Anthony Kenny
      # Mahmoud Khatami
      # Jaegwon Kim
      # Mark Kingwell
      # Robert Kirk
      # Richard Kirkham
      # Philip Kitcher
      # Martha Klein
      # Peter D. Klein
      # Brian Klug
      # William Calvert Kneale
      # Hans Köchler
      # Arthur Koestler
      # Alexandre Kojève
      # John Kok
      # Leszek Kolakowski
      # Hilary Kornblith
      # Stephan Körner
      # Christine Korsgaard
      # Peter Kreeft
      # Georg Kreisel
      # Saul Kripke
      # Julia Kristeva
      # Irving Kristol
      # Erik von Kuehnelt-Leddihn
      # Thomas Samuel Kuhn
      # Will Kymlicka
      # Jacques Lacan
      # Philippe Lacoue-Labarthe
      # Imre Lakatos
      # Michèle Le Dœuff
      # Henri Lefebvre
      # Keith Lehrer
      # Yeshayahu Leibowitz
      # Brian Leiter
      # James G. Lennox
      # Ernest Lepore
      # Isaac Levi
      # Emmanuel Levinas
      # Claude Lévi-Strauss
      # Bernard-Henri Lévy
      # David Kellogg Lewis
      # Suzanne Lilar
      # Alphonso Lingis
      # Gilles Lipovetsky
      # Arthur Lipsett
      # Knud Ejler Løgstrup
      # Bernard Lonergan
      # Paul Lorenzen
      # Roderick T. Long
      # John R. Lucas
      # Peter Ludlow
      # William Lycan
      # Jean-François Lyotard
      # Dwight Macdonald
      # Tibor R. Machan
      # Alasdair MacIntyre
      # Louis Mackey
      # John Leslie Mackie
      # Penelope Maddy
      # Norman Malcolm
      # David Malament
      # Mostafa Malekian
      # Merab Mamardashvili
      # Jon Mandle
      # Claude Mangion
      # Ruth Barcan Marcus
      # Julián Marías
      # Donald A. Martin
      # Michael Martin
      # Abul A'la Maududi
      # George I. Mavrodes
      # Ron McClamrock
      # John McDowell
      # Colin McGinn
      # Terence McKenna
      # Marshall McLuhan
      # Jeff McMahan
      # John McMurtry
      # Alfred Mele
      # David Hugh Mellor
      # Eduardo Mendieta
      # Maurice Merleau-Ponty
      #{NEXT}
      authors = "Thomas Metzinger
      Vincent Miceli
      Mary Midgley
      Alan Millar
      Fred Miller
      Ruth Millikan
      C. Wright Mills
      Richard Montague
      Max More
      J. P. Moreland
      Sidney Morgenbesser
      Adam Morton
      Mou Zongsan
      Iris Murdoch
      Mwalimu Julius
      Kambarage Nyerere
      Arne Næss
      Ernest Nagel
      Thomas Nagel
      Jean-Luc Nancy
      Jan Narveson
      Hossein Nasr
      Stephen Neale
      Antonio Negri
      Oskar Negt
      Alexander Nehamas
      John von Neumann
      Jay Newman
      Kai Nielsen
      Nishitani Keiji
      Kwame Nkrumah
      Nel Noddings
      Ernst Nolte
      Calvin Normore
      Christopher Norris
      David L. Norton
      Robert Nozick
      Martha Nussbaum
      Anthony O'Hear
      Onora O'Neill
      Michael Oakeshott
      Albert Outler
      Gwilyn Ellis Lane Owen
      David Papineau
      Derek Parfit
      John Arthur Passmore
      Jan Patočka
      Christopher Peacocke
      David Pearce
      David Pears
      Jean-Jacques Pelletier
      Leonard Peikoff
      Lorenzo Peña
      Richard Stanley Peters
      Philip Pettit
      Gualtiero Piccinini
      Herman Philipse
      D. Z. Phillips
      Giovanni Piana
      Alexander Piatigorsky
      Robert M. Pirsig
      Alvin Plantinga
      Thomas Pogge
      Louis P. Pojman
      Leonardo Polo
      Richard Popkin
      K. J. Popma
      Karl Popper
      Dag Prawitz
      Graham Priest
      Arthur Prior
      Harry Prosch
      Hilary Putnam
      Andrew Pyle
      Qiu Renzong
      Willard Van Orman Quine
      Anthony Quinton
      Sayyid Qutb
      James Rachels
      Ayn Rand
      Karl Rahner
      Peter Railton
      Tariq Ramadan
      Frank P. Ramsey*
      Ian Thomas Ramsey
      Paul Ramsey
      Jacques Rancière
      Douglas B. Rasmussen
      John Rawls
      Joseph Raz
      George Reisman
      Nicholas Rescher
      Janet Radcliffe Richards
      Radovan Richta
      Paul Ricoeur
      R. R. Rockingham Gill
      Avital Ronell
      Richard Rorty
      Gillian Rose
      Alexander Rosenberg
      Gian-Carlo Rota
      Joseph Rovan
      William L. Rowe
      Michael Ruse
      Gilbert Ryle
      Robert Rynasiewicz
      Mark Sainsbury
      Nathan Salmon
      Wesley Salmon
      Michael J. Sandel
      David H. Sanford
      Prabhat Rainjan Sarkar
      Jean-Paul Sartre
      Crispin Sartwell
      John Ralston Saul
      Fernando Savater
      Thomas Scanlon
      Richard Schacht
      Francis Schaeffer
      Stephen Schiffer
      Hubert Schleichert
      J. B. Schneewind
      Frithjof Schuon
      Roger Scruton
      John Searle
      Wilfrid Sellars
      Amartya Sen
      Michel Serres
      Neven Sesardić
      Stanley Sfekas
      Stewart Shapiro
      Dariush Shayegan
      Abner Shimony
      Sydney Shoemaker
      Richard Shusterman
      Peter Singer
      B. F. Skinner
      John Skorupski
      Brian Skyrms
      Michael Slote
      Peter Sloterdijk
      J. J. C. Smart
      Huston Smith
      Michael A. Smith
      Tara Smith
      Raymond Smullyan
      Joseph D. Sneed
      Scott Soames
      Elliott Sober
      Alan Soble
      Robert C. Solomon
      Joseph Soloveitchik
      Richard Sorabji
      Abdolkarim Soroush
      David Sosa
      Ernest Sosa
      Thomas Sowell
      David Spangler
      Herbert Spiegelberg
      Gayatri Chakravorty Spivak
      Timothy Sprigge
      Edward Stachura
      Robert Stalnaker
      Jason Stanley
      Charles Leslie Stevenson
      Stephen Stich
      Bernard Stiegler
      Dejan Stojanović
      Jeffrey Stout
      David Stove
      Galen Strawson
      P. F. Strawson
      Gisela Striker
      Barry Stroud
      Patrick Suppes
      Richard Swinburne
      David Sztybel
      Javad Tabatabai
      Nassim Nicholas Taleb
      Robert B. Talisse
      Tang Junyi
      Alfred Tarski
      Charles Taylor
      Richard Taylor
      Placide Tempels
      Neil Tennant
      Irving Thalberg Jr.
      Helmut Thielicke
      Judith Jarvis Thomson
      Tzvetan Todorov
      Stephen Toulmin
      Peter Tudvad
      Ernst Tugendhat
      Raimo Tuomela
      Alan Turing
      Peter Unger
      Ivo Urbančič
      Alasdair Urquhart
      Bas van Fraassen
      Peter van Inwagen
      Philippe Van Parijs
      Francisco Varela
      Juha Varto
      Gianni Vattimo
      Achille Varzi
      Adolfo Sánchez Vázquez
      Henry Babcock Veatch
      Michel Villey
      Gregory Vlastos
      Eric Voegelin
      Jules Vuillemin
      Georg Henrik von Wright
      Margaret Urban Walker
      Doug Walton
      Kendall Walton
      Michael Walzer
      Ernest Wamba dia Wamba
      Hao Wang
      Georgia Warnke
      Geoffrey J. Warnock
      Mary Warnock
      Alan Watts
      Brian Weatherson
      Simone Weil
      Morris Weitz
      Carl Friedrich von Weizsäcker
      Albrecht Wellmer
      Cornel West
      Jennifer Whiting
      David Wiggins
      John Daniel Wild
      Dallas Willard
      Bernard Williams
      Timothy Williamson
      Jessica Wilson
      Margaret Dauler Wilson
      Peter Winch
      Kwasi Wiredu
      John Wisdom
      Charlotte Witt
      Monique Wittig
      Susan R. Wolf
      Ursula Wolf
      Richard Wollheim
      Nicholas Wolterstorff
      Paul Woodruff
      Crispin Wright
      Jerzy Wróblewski
      Alison Wylie
      Xu Liangying
      Cemal Yıldırım
      Francis Parker Yockey
      Arthur M. Young
      Damon Young
      Iris Marion Young
      Jiyuan Yu
      Santiago Zabala
      Naomi Zack
      Linda Trinkaus Zagzebski
      Dan Zahavi
      José Zalabardo
      Edward N. Zalta
      Marlène Zarader
      Ingo Zechner
      Eddy Zemach
      John Zerzan
      Yujian Zheng
      Zhai Zhenming
      Zhou Guoping
      Paul Ziff
      Robert Zimmer
      Dean Zimmerman
      Michael E. Zimmerman
      Alexander Zinoviev
      Slavoj Žižek
      Elémire Zolla
      Volker Zotz
      François Zourabichvili
      Estanislao Zuleta
      Alenka Zupančič
      Jan Zwicky
    ".split("\n")
    authors.each do |author|
      q = Query.new([author], 'philosophy', 1)
      start_count = Publication.count
      cr = CrossRefDispatcher.new(q)
      cr.dispatch
      pubs = cr.response
      PubSaver.save(pubs)
      puts "#{author} (+ #{Publication.count - start_count})"
      sleep 5
    end
  end
end
