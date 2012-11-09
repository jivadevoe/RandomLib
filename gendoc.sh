#/bin/sh

rm -rf Docs
mkdir Docs

/usr/local/bin/appledoc --project-name=RandomLib --project-company='Random Ideas, LLC' --company-id='com.randomideas' `find . -name '*.h'`

/usr/local/bin/appledoc --no-create-docset -h -o Docs --project-name=RandomLib --project-company='Random Ideas, LLC' `find . -name '*.h'`

true
