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
CV_BASE_PATH=../xml
if [[ -z "${CV_TITLE}" ]]; then
  CV_TITLE=example1
fi
CV_FILE=$CV_BASE_PATH/$CV_TITLE-filtered

# escape & from last run
sed 's/\&/\&amp;/g' $CV_FILE.xml >  $CV_FILE-fixed.xml
rm $CV_FILE.xml
mv $CV_FILE-fixed.xml $CV_FILE.xml

# run resume creating txt, html and fop versions
$ANT_HOME/bin/ant -Dresume=$CV_FILE clean txt html fo

mv $CV_FILE.txt $CV_TITLE-$NOWDATE.txt
mv $CV_FILE.html $CV_TITLE-$NOWDATE.html

# create an rtf version from fo
java com.xmlmind.fo.converter.Driver $CV_FILE.fo > $CV_TITLE-$NOWDATE.rtf

# create an pdf version from fo
java org.apache.fop.cli.Main -fo $CV_FILE.fo -pdf $CV_TITLE-$NOWDATE.pdf

OUT_DIR=../generated
echo "genrated files to be writtem to $OUT_DIR"
rm -rf $OUT_DIR
mkdir $OUT_DIR
mv $CV_TITLE-$NOWDATE.* $OUT_DIR

# zip into archive
zip $OUT_DIR/$CV_TITLE-$NOWDATE.zip $OUT_DIR/$CV_TITLE-$NOWDATE.*

# remove old filtered xml
rm $CV_FILE.xml
