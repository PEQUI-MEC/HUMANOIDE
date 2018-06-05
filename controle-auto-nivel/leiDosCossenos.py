#!/usr/bin/env python
 # license removed for brevity
import math

a = 7.5
c = 7.6
altura = 14.
pos_inicial_pelves = [0., 0., altura]
pos_inicial_foot = [0., 0., -altura]

deslocamentoXpes = 3
deslocamentoYpelves = 2
deslocamentoZpes = 3
nEstados = 125
tempoPasso = 4

def footToHip(pointHip):
	angulos = []
	x,y,z = pointHip
	theta = math.atan(y/x)
	#print('footToHip',x,y,theta)
	angulos.append(theta)
	b = math.sqrt(x**2+y**2+z**2)
	anguloA = math.acos((a**2-(b**2+c**2))/(-2*b*c))
	angulos.append(anguloA)
	anguloB = math.acos((b**2-(a**2+c**2))/(-2*a*c))
	angulos.append(anguloB)
	anguloC = math.acos((c**2-(a**2+b**2))/(-2*a*b))
	angulos.append(anguloC)
	angulos.append(-1*theta)
	angulos.append(0)
	return angulos

def hipToFoot(pointFoot):
	angulos = []
	x,y,z = pointFoot
	theta = math.atan(y/x)
	
	angulos.append(theta)
	#print('hipToFoot',x,y,theta)
	b = math.sqrt(x**2+y**2+z**2)
	anguloA = math.acos((a**2-(b**2+c**2))/(-2*b*c))
	angulos.append(anguloA)
	anguloB = math.acos((b**2-(a**2+c**2))/(-2*a*c))
	angulos.append(anguloB)
	anguloC = math.acos((c**2-(a**2+b**2))/(-2*a*b))
	angulos.append(anguloC)
	angulos.append(-1*theta)
	angulos.append(0)
	return angulos

def getTragectoryPoint(x):
	pos_pelves = pos_inicial_pelves
	p = (deslocamentoXpes/2)*((math.exp((2*(x-nEstados/2))/50) - math.exp((2*(x-nEstados/2))/-50))/(math.exp((2*(x-nEstados/2))/50)+math.exp((2*(x-nEstados/2))/-50)))
	pos_pelves[0] = p
	pos_pelves[1] = -deslocamentoYpelves*math.sin(x*math.pi/nEstados)

	pos_foot = pos_inicial_foot
	pos_foot[0] = (-deslocamentoXpes/2)*((math.exp((2*(x-nEstados/2))/50) - math.exp((2*(x-nEstados/2))/-50))/(math.exp((2*(x-nEstados/2))/50)+math.exp((2*(x-nEstados/2))/-50)))
	pos_foot[2] = -altura+deslocamentoZpes*math.exp(-((x-nEstados/2)**2)/600)
	return pos_pelves, pos_foot
