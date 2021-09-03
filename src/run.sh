# setup
export XFC_HOME=../../xfc-42p1
export ANT_HOME=../apache-ant-1.9.4

CLASSPATH=
for i in $(ls ../lib/*.jar)
do
   CLASSPATH=$CLASSPATH:$i
done
export CLASSPATH=../java/xmlresume-filter.jar:fop$FOP_VERSION.jar:$CLASSPATH
echo $CLASSPATH
NOWDATE=`date +%Y%m%d`
CV_BASE_PATH=../xml
if [[ -z "${CV_TITLE}" ]]; then
  CV_TITLE=example1
  cp ../example/example1.xml ../xml
fi

CV_FILE=$CV_BASE_PATH/$CV_TITLE

# run resume applying an empty filter so that items with targets are not generated
echo "run resume applying an empty filter so that items with targets are not generated"
$ANT_HOME/bin/ant  -Dfilter.targets="" -Dresume=$CV_FILE clean filter

# run build to generate from the filtered CV
echo "now generating the filtered CV"
$PWD/do-generation.sh
