#!/bin/bash

#Shellscript: Scrip.bash
#Nome: Pedro Henrique Bendik Rech(pedrohenrique.rech@gmail.com)
#Função: Transferencia de Arquivos SCP e Rsync
#Data: 19/07/2017
#Disciplina: Engenharia de Software



#Criação do Arquivo de Log

DIR_LOG=~ log_backup/bk_`date +%d-%m_%H%M`.log

#Verifica se o Diretório existe, caso não cria o mesmo. 
if [ ! -d /log_backup  ]; then
	mkdir ~/log_backup;
fi


#Menu Principal(Aqui é o menu, onde o cliente vai selecionar a opção desejada)

Menu(){
	x="teste"
	while true $x != "teste"; do
	clear
	echo "==========================================================="
	echo "Menu Principal:                                           #"                   
	echo "                                                          #"
	echo "                                                          #"
	echo "1-Criar pacote de Arquivos:                               #"
	echo "2-Transferencias de Arquivos - SCP: Local                 #"
	echo "3-Transferencias de Arquivos - SCP: Remoto                #"
	echo "4-Transferencias de Arquivos - RSYNC: Local               #"
	echo "5-Transferencias de Arquivos - RSYNC: Remoto              #"
	echo "6-Sair                                                    #"
	echo "==========================================================="
	echo
	echo "Digite sua escolha: "
	read x
		case $x in
			1)CRIAR_ARQUIVOS
			2)TRANSF_SCP_LOCAL
			3)TRANSF_SCP_REMOTO
			4)TRANSF_RSYNC_LOCAL
			5)TRANSF_RSYNC_REMOTO
			6)EXIT
			*)INVALIDO
	
}
CRIAR_ARQUIVOS(){
	#Este script cria algumas pastas com arquivos para testes de transferência pela rede
	#O conteúdo destes arquivos é pseudorrandômico, atravéz de /dev/urandom
	#criação das pastas
	mkdir ~/benckmarks ;
	mkdir ~/benckmarks/1 ;
	mkdir ~/benckmarks/2 ;
	mkdir ~/benckmarks/3 ;

	#cria 1000 arquivos de tamanho aleatório
	for counter in {1..1000} ;
	do 
		dd if=/dev/urandom of=~/benckmarks/1/arquivo_$counter.rdm bs=$(($RANDOM % 100 + 1)) count=1000 ; 
	done

	#cria um arquivo de 100MB
	dd if=/dev/urandom of=~/benckmarks/2/arquivo2.rdm bs=1M count=100 ;

	#cria um arquivo de 1GB
	dd if=/dev/urandom of=~/benckmarks/3/arquivo3.rdm bs=1M count=1000 ;

}
TRANSF_SCP_LOCAL(){
	#verificar se o usuario é root
	if [[ `whoami` == "root" ]];then
		echo "Transferência SCP Local->Remoto..."
		scp -r ~benckmarks/ pedro@:192.168.0.111/home/pedro
	else
		echo "Você deve estar Logado como root para executar essa operação"
	fi
}
TRANSF_SCP_REMOTO(){
	#verificar se o usuario é root
	if [[ `whoami` == "root" ]];then
		echo "Transferência SCP Remoto->Local..."
		scp -r pedro@:192.168.0.111/home/pedro/benckmarks ~/
	else
		echo "Você deve estar Logado como root para executar essa operação"
	fi
}
TRANSF_RSYNC_LOCAL(){
	#verificar se o usuario é root
	if [[ `whoami` == "root" ]];then
		echo "Transferência RSYNC Local->Remoto..."
		$ rsync -Cravzp ~/benckmarks pedro@:192.168.0.111/home/pedro
			echo "Backup Realizado com Sucesso!"
		
	else
		echo "Você deve estar Logado como root para executar essa operação"
	fi
}
TRANSF_RSYNC_REMOTO(){
	#verificar se o usuario é root
	if [[ `whoami` == "root" ]];then
		echo "Transferência RSYNC Remoto->Local..."
		$ rsync -Cravzp pedro@192.168.0.111:/home/pedro/benckmarks ~/ 
			echo "Backup Realizado com Sucesso!"
	else
		echo "Você deve estar Logado como root para executar essa operação"
	fi
}
EXIT(){
	clear;
	exit;
}
INVALIDO(){
	echo "Opção Invalida!"
}