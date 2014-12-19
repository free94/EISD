#!/usr/bin/python
# -*-coding:utf-8 -*

from __future__ import print_function

with open("Prenoms.txt", "r") as inputfile:
	with open("prenoms-fr.txt", "w") as outputfile:
		for line in inputfile:
			infos = line.split("\t")
			if "french" in infos[2]:
				print(infos[0].split(" ")[0].capitalize(), file=outputfile)