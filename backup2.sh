#!/bin/bash
# Jovana Petrovic 1625
# Skripta za bekap.

#Prvi parametar skripte je ime bekapa (log fajl, odredisni dir).
if [ -n "$1" ]; then
    BACKUP_NAME=$1  
else 
    exit 1
fi

# Drugi parametar skripte je ime hosta, tj. hostname. Ovo je opcioni parametar.
if [ -n "$2" ]; then
    HOST_NAME=$2          
else 
    HOST_NAME=""
fi

# Treci parametar je izvorisni folder, odnosno fajlovi koje cemo da bekapujemo.
if [ -n "$3" ]; then 
    if [ -n "$HOST_NAME" ]; then 
        SRC=${HOST_NAME}:$3
    else 
        SRC=$3         
    fi    
else 
    exit 1
fi

# Cetvrti parametar je lokacija repozitorijuma.
if [ -n "$4" ]; then
    REPO_NAME=$4  
else 
    exit 1
fi

# Kao peti parametar ide odgovarajuca SSH komanda.
if [ -n "$5" ]; then
    SSH_COMMAND=$5  
else 
    SSH_COMMAND=""
fi

# Sesti i poslednji parametar je mejl adresa na koju se salje izvestaj.
if [ -n "$6" ]; then
    EMAIL=$6        
else
    exit 1
fi

# Potrebne varijable (direktorijum, odrediste, log izvestaj)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
DEST="$REPO_NAME$BACKUP_NAME"
LOG_NAME="$DIR/$BACKUP_NAME.log"

DATE=`date +%Y-%m-%d`   # Kompletan datum u obliku 2015-05-27.
DOW=`date +%w`          # Prvi dan u nedelji je ponedeljak.
DOM=`date +%d`          # Dan u mesecu, npr. 18.

# Ukoliko sledeci direktorijumi u bekapu ne postoje, kreirati ih.
if [ ! -d "$DEST/latest_backup" ]; then
    mkdir -p $DEST/latest_backup
fi
if [ ! -d "$DEST/Daily" ]; then
    mkdir $DEST/Daily
fi
if [ ! -d "$DEST/Weekly" ]; then
    mkdir $DEST/Weekly
fi
if [ ! -d "$DEST/Monthly" ]; then
    mkdir $DEST/Monthly
fi

# Mesecni bekap, vrsi se svakog prvog u mesecu.
if [ $DOM = "01" ]; then
        DATE_DEST=$DEST/Monthly/`date +%B`

# Nedeljni bekap, vrsi se ponedeljkom.
elif [ $DOW = "1" ]; then
    	DATE_DEST=$DEST/Weekly/$DATE

# Inkrementalni bekap, brise se bekap iz prethodnih nedelja.
else
	DATE_DEST=$DEST/Daily/`date +%A`
fi

# Izvrsavanje rsync komande.
rsync -e "$SSH_COMMAND" --rsync-path=/usr/bin/rsync -az --numeric-ids --stats --human-readable –delete --link-dest=$DEST/latest_backup $SRC $DEST/ > $LOG_NAME 2>&1 && cat $LOG_NAME | mail -s "Rsync $BACKUP_NAME: Bekap uspesan" $EMAIL || cat $LOG_NAME | mail -s "Rsync $BACKUP_NAME: Bekap neuspesan" $EMAIL

# Brisanje postojeceg direktorijuma.
if [ -d "$DATE_DEST" ]; then
    rm -rf $DATE_DEST
fi

# Smestanje bekapa u odredisni direktorijum i postavljanje nove reference na direktorijum.
mv $DEST/ $DATE_DEST
rm -rf $DEST/latest_backup 
ln -s $DATE_DEST $DEST/latest_backup
