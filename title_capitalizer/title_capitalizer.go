package title_capitalizer

import  (
  "strings"
  "fmt"
)

func Titlize (stringToTitlize string) (titlizedString string) {
  if len(stringToTitlize) == 0 { return "" }
  nonCapitalizedWords := [...]string{" a ",
                                     " about ",
                                     " across ",
                                     " after ",
                                     " against ",
                                     " among ",
                                     " amid ",
                                     " an ",
                                     " and ",
                                     " around ",
                                     " as ",
                                     " at ",
                                     " before ",
                                     " behind ",
                                     " below ",
                                     " beneath ",
                                     " besides ",
                                     " between ",
                                     " beyond ",
                                     " but ",
                                     " by ",
                                     " concerning ",
                                     " despite ",
                                     " down ",
                                     " during ",
                                     " except ",
                                     " excluding ",
                                     " following ",
                                     " for ",
                                     " from ",
                                     " in ",
                                     " inside ",
                                     " into ",
                                     " like ",
                                     " near ",
                                     " nor ",
                                     " of ",
                                     " off ",
                                     " on ",
                                     " onto ",
                                     " or ",
                                     " outside ",
                                     " over ",
                                     " past ",
                                     " per ",
                                     " since ",
                                     " than ",
                                     " the ",
                                     " through ",
                                     " to ",
                                     " towards ",
                                     " under ",
                                     " underneath ",
                                     " unlike ",
                                     " until ",
                                     " up ",
                                     " upon ",
                                     " versus ",
                                     " via ",
                                     " with ",
                                     " within ",
                                     " without "}
  updatedString := strings.Title(stringToTitlize)
  updatedString = replaceWithLowerCase(updatedString, nonCapitalizedWords)
  stringArr := strings.Split(updatedString, "")
  stringArr[0] = strings.ToUpper(string(updatedString[0]))
  fmt.Println(stringArr[0])
  return strings.Join(stringArr, "")
}

func replaceWithLowerCase (stringToReplace string, replacedStrings [62]string) (updatedString string) {
  updatedString = stringToReplace
  for _, str := range replacedStrings {
    updatedString = strings.Replace(updatedString, strings.Title(str), strings.ToLower(str), 6)
  }
  return updatedString
}
