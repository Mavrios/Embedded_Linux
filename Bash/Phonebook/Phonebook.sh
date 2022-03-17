#!/bin/bash
#VARIABLE TO CREATE WITH DATABASE NAME
FILE=PhoneBookDb
FILETMP=PhoneBook.Tmp

#CHECK IF THE FILE IS ALREADY EXIST OR NOT!!
if [ ! -f "$FILE" ]
then
	##CREATE DATABASE FILE WITH INITIALIZED CONTACT NAME AND PHONE NUMBER
	printf "%-30s%-14s\n" "Contact Name" "Phone Number" > $FILE
fi


# FUNCTION TO DISPLAY ALL OPTIONS
DisplayOptions () {
	echo "-i Insert New Contact"
	echo "-v View all saved contacts details"
	echo "-s Search by contanct name in the phonebook database"
	echo "-e Delete all records"
	echo "-d Delete one contact name"
}

#FUNCTION TO INSERT CONTACTS
InsertContact () {
	#READ CONTACT NAME
	echo "Please Enter Contact Name: "
	read Contact_Name
	#CHECK IF THE CONTACT NAME IS DUPLICATED
	if grep -q "$Contact_Name" $FILE
	then
		echo "Duplicated Contact Name!!"
		Duplication=1
	else
		Duplication=0
	fi
	#IF NOT DUPLICATED NAME GET THE PHONE NUMBER
	if [ $Duplication == 0 ]
	then
		echo "Please Enter Phone Number: "
		read Phone_Number	
		#LOOP TO VALIDATE THE PHONE NUMBER IS DIGITS
		while ! [[ "$Phone_Number" =~ ^[0-9]+$ ]] ;
		do
			echo "Please Enter Phone Number "ONLY DIGITS": "
			read Phone_Number
		done
		#APPEND THE CONTACT DATA TO THE DATABASE
		printf "%-20s%-14s\n" "$Contact_Name" "$Phone_Number" >> $FILE
	fi
}

#FUNCTION TO PRINT ALL DATABASE
ViewContacts () {
	cat $FILE
}

#FUNCTION TO PRINT SPECIFIC CONTACT INFORMATIONS
ViewSpecificContact() {
	echo "Enter Contact Name To search: "
	read Contact_Name
	#CHECK IF THE CONTACT IS EXIST 
	if  grep -q "$Contact_Name" $FILE
	then
		grep "$Contact_Name" $FILE
	else
		echo "Not Fount!!"
	fi
}

#FUNCTION TO DELETE ALL DATABASE
DeleteAllRecords () {
	printf "%-30s%-14s\n" "Contact Name" "Phone Number" > $FILE
}

#FUNCTION TO DELETE SPECIFIC CONTACT NAME
DeleteSpecificContact () {
        echo "Enter Contact Name To Delete: "
        read Contact_Name
        if  grep -q "$Contact_Name" $FILE
        then
		sed -i '/$ContactName/d' $FILE
        	grep -F -v "$Contact_Name" $FILE > $FILETMP && mv $FILETMP $FILE
        else
                echo "Not Fount!!"
        fi

}

#CHECK THE PASSED ARGUMENT TO SCRIPT

if [ -z $1 ] || [ ! -z $2 ]
then
	DisplayOptions
elif [ $1 == "-i" ]
then
 	InsertContact
elif [ $1 == "-v" ]
then
	ViewContacts
elif [ $1 == "-s" ]
then
	ViewSpecificContact
elif [ $1 == "-e" ]
then
	DeleteAllRecords
elif [ $1 == "-d" ]
then
	DeleteSpecificContact
fi

