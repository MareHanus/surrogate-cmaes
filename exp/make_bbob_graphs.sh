#!/bin/bash

# make_bbob_graphs -i [BBOB_RAW_DIR] -o [PPDATA_OUTPUT_DIR] -e [EXPID] [ALGNAME1] [ALGNAME2] ...
# 

#Initialize cmdopts default values
BBOB_RAW_DIR="."        # -i
OUTPUT_DIR='ppdata' # -o
EXPID="exp_SCMAES_01"   # -e

CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Help function
function HELP {
  #Set fonts for Help.
  NORM=`tput sgr0`
  BOLD=`tput bold`
  REV=`tput smso`
  echo -e "\nUsage:\n$SCRIPT -i [BBOB_RAW_DIR] -o [PPDATA_OUTPUT_DIR] -e [EXPID] [ALGNAME1] [ALGNAME2] ...\n"
  echo "Command line switches are optional. The following switches are recognized."
  echo "  ${REV}-i${NORM}  --Directory with raw BBOB input data. Default is '${BOLD}${BBOB_RAW_DIR}${NORM}'."
  echo "  ${REV}-o${NORM}  --Directory where to put BBOB parsed data. Default is '${BOLD}${OUTPUT_DIR}${NORM}'."
  echo "  ${REV}-e${NORM}  --EXPID of the current experiment. Default is '${BOLD}${EXPID}${NORM}'."
  echo -e "  ${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -i bbob_raw/ -o ppdata/ -e exp_CMA-ES_01 GP1_CMAES GP5_CMAES${NORM}"\\n
  exit 1
}

if [ "$#" -eq 0 ]; then
  HELP
fi

while getopts "i:o:e:h" FLAG; do
  case $FLAG in
    i)  #set option "i"
      BBOB_RAW_DIR=$OPTARG
      ;;
    o)  #set option "o"
      OUTPUT_DIR=$OPTARG
      ;;
    e)  #set option "e"
      EXPID=$OPTARG
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done
shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

DATADIR="$CWD/../log/bbob_data/$EXPID"

if [ -d "$DATADIR" ]; then
  echo Directory with the BBOB data already exists:
  echo "$DATADIR"
  echo ""
  echo "!!! Omitting BBOB data transformation !!!"
  echo ""
else
  mkdir -p $DATADIR
  echo -e "\n$CWD/split_bbob_results.sh -i $BBOB_RAW_DIR -o $DATADIR -e $EXPID $*\n"
  $CWD/split_bbob_results.sh -i $BBOB_RAW_DIR -o $DATADIR -e $EXPID $*
fi

# computer dependent -> Lukas will probably rewrite it
#python $CWD/vendor/bbob_pproc/rungeneric.py --expensive $DATADIR/* -o $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
cd $DATADIR
python $CWD/vendor/bbob_pproc/rungeneric.py --expensive --in-a-hurry 0 -o $OUTPUT_DIR *
