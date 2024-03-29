all:
	curl --silent https://support.oculus.com/343060616597701/ | sed -e 's/>/>\n/g' | grep -o -E "app%2F[[:alnum:]]*" | sed -e 's/app%2F//g' | uniq | xargs -I{} sh -c 'echo { && echo "\"id\":\"{}\"," && curl --silent https://www.oculus.com/experiences/go/{}/ | grep -o -E "\"name\":\"[[:alnum:][:blank:][:punct:]]{1,100}\",|\"ratingValue\":[[:digit:]\.]*|\"price\":\"[[:digit:]\.]*\",|\"image\":\[\"https:[^\"]*\"," | sed -e "s/\":\[\"/\":\"/g" && echo }' | jq -s -c 'sort_by(-.ratingValue)' > data.json
	mkdir build
	cp data.json build/data.json
	cp index.html build/index.html
	touch build/.nojekyll
