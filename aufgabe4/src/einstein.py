#!/usr/bin/env python
# -*- coding: utf-8 -*-

import CSP
import math


domain = [1,2,3,4,5]

csp = CSP.CSP()

nation = ['brite','schwede','daene','norweger','deutscher']

farbe = ['rot','gruen','weiss','gelb','blau']

tier = ['hund','vogel','katze','pferd','fisch']

getraenk = ['tee','kaffee','milch','bier','wasser']
	
zigarette = ['pallmall','dunhill','malboro','winfield','rothmanns']

for n,f,t,z in zip(nation,farbe,tier,zigarette):
	csp.addKnoten(n,domain)
	csp.addKnoten(f,domain)
	csp.addKnoten(t,domain)
	csp.addKnoten(z,domain)

gleich = lambda a, b: a == b
mittelHaus = lambda a: a == 3
nachbarn = lambda a, b: math.abs(a-b) == 1
linksVon = lambda a, b: a < b
rechtsVon = lambda a, b: a > b
erstesHaus = lambda a: a == 1

csp.addConstraint(('brite','rot',gleich))				# 1. Der Brite lebt im roten Haus.
csp.addConstraint(('schwede','hund',gleich))			# 2. Der Schwede hält sich einen Hund.
csp.addConstraint(('daene','tee',gleich))				# 3. Der Däne trinkt gern Tee.
csp.addSgConstraint(('gruen','weiss',linksVon)) 		# 4. Das grüne Haus steht links neben dem weißen Haus.
csp.addSgConstraint(('weiss','gruen',rechtsVon)) 		# 4. Das grüne Haus steht links neben dem weißen Haus.
csp.addConstraint(('gruen','kaffee',gleich)) 			# 5. Der Besitzer des grünen Hauses trinkt Kaffee.
csp.addConstraint(('pallmall','vogel',gleich))			# 6. Die Person, die Pall Mall raucht, hat einen Vogel.
csp.addConstraint(('milch','milch',mittelHaus))			# 7. Der Mann im mittleren Haus trinkt Milch.
csp.addConstraint(('gelb','dunhill',gleich))			# 8. Der Bewohner des gelben Hauses raucht Dunhill.
csp.addConstraint(('norgweger','norweger',erstesHaus))	# 9. Der Norweger lebt im ersten Haus.
csp.addConstraint(('malboro','katze',nachbarn))			# 10. Der Malboro-Raucher wohnt neben der Person mit der Katze.
csp.addConstraint(('pferd','dunhill',nachbarn))			# 11. Der Mann mit dem Pferd lebt neben der Person, die Dunhill raucht.
csp.addConstraint(('winfield','bier',gleich))			# 12. Der Winfield-Raucher trinkt gern Bier.
csp.addConstraint(('norwerger','blau',nachbarn))		# 13. Der Norweger wohnt neben dem blauen Haus.
csp.addConstraint(('deutscher','rothmanns',gleich))		# 14. Der Deutsche raucht Rothmanns.
csp.addConstraint(('malboro','wasser',nachbarn))		# 15. Der Malboro-Raucher hat einen Nachbarn, der Wasser trinkt.

ungleich = lambda a, b: a != b

def alleUngleich(liste):
	for e1 in liste:
		for e2 in liste:
			if e1 != e2:
				csp.addConstraint((e1,e2,ungleich))
				
alleUngleich(nation)
alleUngleich(farbe)
alleUngleich(tier)
alleUngleich(getraenk)
alleUngleich(zigarette)

solution = csp.solve()

print csp.knoten