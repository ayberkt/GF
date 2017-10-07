rm -f tur.out
cat tur.tests | sed 's/^/l -lang=LangTur /' | gf --run ../../lib/src/turkish/LangTur.gf | sed  '/^$/d' > tur.out

COUNT=0
while true; do
  read -r f1 <&3 || break
  read -r f2 <&4 || break
  read -r f3 <&5 || break
  if [[ $f1 == $f2 ]]; then
    printf "$COUNT  | \"$f1\" ----- \e[1m\e[32m SUCCESS \e[0m\n"
  else
    printf "$COUNT  | \"$f1\" ----- \e[1m\e[31m FAILURE \e[0m\n"
    printf "\n----------------------------------------\n"
    printf "Linearization of\n"
    printf "   > $f3\n"
    printf "did not match the expected output\n"
    printf "   > $f1\n"
    printf "%s\n" "-----------------------------------------"
  fi;
  (( COUNT+=1 ));
done 3<tur.out 4<tur.expected 5<tur.tests
rm tur_out.txt
