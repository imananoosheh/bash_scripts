#define _XOPEN_SOURCE 700
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <stdbool.h>


char *filename;
char *fntemp;
bool found;
int search(const char *dirname, const struct stat *sb, int typeflag, struct FTW *ftwbuf);
void basename1(char *dir);

int main(int argc, char *argv[]){
	filename = (char *)malloc(64);
	fntemp = (char *)malloc(64);
	found = false;
	if(argc>3 || argc<2){
	fprintf(stderr, "\n\tUsage: %s <file-name> [target-directory(default==\"/\")]\n", argv[0]);
	printf("\n\t<file-name> without a extension will be searched in directorys' name too.\n\n\n");
	exit(0);
	}
	if(argc==3){
		//snprintf(destination,string-max-lengh,format-string,source)
		snprintf(filename,64,"%s",argv[1]);  
		if (nftw(argv[2], search, 25, 0) == -1) {
			perror("Call to nftw failed");
			exit(0);
		}
	}
	if(argc==2){
		printf("Warning: current directory is selected to search within\n");
		snprintf(filename,64,"%s",argv[1]);  
		if (nftw(".", search, 25, 0) == -1) {
			perror("Call to nftw failed");
			exit(0);
		}
	}
	if(found == false)
		printf("\n\tNO FILE FOUND!\n\n");
}

void basename1(char *dir){
	int fdlen = strlen(dir);
	int pos = 0;
	int counter = 0;
	char filenametemp[64]="";
	for (int i=fdlen-1; i>=0; i--){
		if(dir[i]=='/'){
			pos = i;
			break;
		}
	}
	for(int i=pos+1; i<fdlen; i++){
		if(counter==fdlen-pos-1)
			break;
		filenametemp[counter]=dir[i];
		counter++;
	}
	strcpy(fntemp,filenametemp);
}

int search(const char *dirname, const struct stat *sb, int typeflag, struct FTW *ftwbuf){
	char currfn[64];
	char inputfn[64];
	basename1(dirname);
	strcpy(currfn,fntemp);
	strcpy(inputfn,filename);
	if(strcmp(dirname,".")==0)
		return 0;
	if(typeflag == FTW_F){
		strcpy(currfn,strtok(currfn,"."));
		if(strtok(inputfn,".")==NULL)
			strcpy(inputfn,filename);
		else
			strcpy(inputfn,strtok(inputfn,"."));
	}
	//comment below is for debugging purpose
	//printf("dirname:%-25s|currfn[len]:%-25s[%d]|inputfn[len]:%-25s[%d]\n",dirname,currfn,strlen(currfn),inputfn,strlen(inputfn));
	if(!strcmp(currfn, inputfn)){
		found = true;
		if(typeflag == FTW_D || typeflag == FTW_DNR){
			printf("\033[01;33m");
			printf("DIRECTORY	| %-24s		| %s", fntemp, dirname);
			puts("\033[0m");
			}
		if(typeflag == FTW_F){
			printf("\033[01;37m");
			printf("FILE		| %-24s		| %s", fntemp, dirname);
			puts("\033[0m");
			}
	}
	return 0;

}
