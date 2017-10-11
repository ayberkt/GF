rm -f tur.out
cat tur.tests | sed 's/^/l -lang=LangTur /' | gf --run ../../lib/src/turkish/LangTur.gf | sed  '/^$/d' > tur.out

COUNT=0
while true; do
  read -r f1 <&3 || break
  read -r f2 <&4 || break
  read -r f3 <&5 || break
  # Alignment should be done for this.
  if [[ $f1 == $f2 ]]; then
    printf "$COUNT  | \"%s\" ..........  \e[1m\e[32m %s \e[0m\n" "$f1" "SUCCESS"
  else
    printf "$COUNT  | \"%s\" ..........  \e[1m\e[31m %s \e[0m\n" "$f1" "FAILURE"
    printf "\n----------------------------------------\n"
    printf "Linearization of\n"
    printf "   > $f3\n"
    printf "did not match the expected output\n"
    printf "   > $f1\n"
    printf "%s\n" "-----------------------------------------"
  fi;
  (( COUNT+=1 ));
done 3<tur.out 4<tur.expected 5<tur.tests
rm tur.out
