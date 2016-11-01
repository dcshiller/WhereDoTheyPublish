package titlecap


import  (
  "strings"
  "fmt"
)

func Titlize (stringToTitlize string) (titlizedString string) {
  nonCapitalizedWords := [...]string{" a "," an "," and "," at "," but "," by "," for "," from "," in "," nor ", " of "," on "," or "," the "}
  updatedString := strings.Title(stringToTitlize)
  updatedString = replaceWithLowerCase(updatedString, nonCapitalizedWords)
  // fmt.Println(replaceWithLowerCase("An of The a Or", nonCapitalizedWords))
  stringArr := strings.Split(updatedString, "")
  stringArr[0] = strings.ToUpper(string(updatedString[0]))
  fmt.Println(stringArr[0])
  return strings.Join(stringArr, "")
}

func replaceWithLowerCase (stringToReplace string, replacedStrings [14]string) (updatedString string) {
  updatedString = stringToReplace
  for _, str := range replacedStrings {
    // fmt.Println(updatedString)
    // fmt.Println("Replace " + str)
    updatedString = strings.Replace(updatedString, strings.Title(str), strings.ToLower(str), 6)
    // fmt.Println(updatedString)
  }
  return updatedString
}
