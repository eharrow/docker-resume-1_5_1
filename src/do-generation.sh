# setup
export XFC_HOME=../../xfc-42p1
export ANT_HOME=../apache-ant-1.9.4

CLASSPATH=
for i in $(ls ../lib/*.jar)
do
   CLASSPATH=$CLASSPATH:$i
done
export CLASSPATH=fop$FOP_VERSION.jar:$CLASSPATH
echo $CLASSPATH
NOWDATE=`date +%Y%m%d`
CV_TITLE_NAME=ewanharrow-cv
CV_TITLE=$CV_TITLE_NAME-filtered

# escape & from last run
sed 's/\&/\&amp;/g' $CV_TITLE.xml >  $CV_TITLE-fixed.xml
rm $CV_TITLE.xml
mv $CV_TITLE-fixed.xml $CV_TITLE.xml

# run resume creating txt, html and fop versions
$ANT_HOME/bin/ant -Dresume=$CV_TITLE clean txt html fo

mv $CV_TITLE.txt $CV_TITLE_NAME-$NOWDATE.txt
mv $CV_TITLE.html $CV_TITLE_NAME-$NOWDATE.html

# create an rtf version from fo
java com.xmlmind.fo.converter.Driver $CV_TITLE.fo > $CV_TITLE_NAME-$NOWDATE.rtf

# create an pdf version from fo
java org.apache.fop.cli.Main -fo $CV_TITLE.fo -pdf $CV_TITLE_NAME-$NOWDATE.pdf

rm -rf generated
mkdir generated
mv $CV_TITLE_NAME-$NOWDATE.* generated

# zip into archive
zip generated/$CV_TITLE_NAME-$NOWDATE.zip generated/$CV_TITLE_NAME-$NOWDATE.*

# remove old filtered xml
rm $CV_TITLE.xml
