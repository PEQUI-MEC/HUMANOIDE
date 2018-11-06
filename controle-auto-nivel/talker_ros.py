#!/usr/bin/env python
 # license removed for brevity
import rospy
from std_msgs.msg import Float32MultiArray
from leiDosCossenos import footToHip, hipToFoot, getTragectoryPoint,nEstados,tempoPasso

def talker():
	pub = rospy.Publisher('Bioloid/cmd_vel', Float32MultiArray, queue_size=1)
	rospy.init_node('publisher', anonymous=True)
	rate = rospy.Rate(tempoPasso/nEstados) # 10hz
	mat = Float32MultiArray()
	time = 0
	flag = True

	while not rospy.is_shutdown():
		ponto1, ponto2 = getTragectoryPoint(time)
		if flag is True:
			mat.data = footToHip(ponto1) + hipToFoot(ponto2) + [0]*6
		else:
			mat.data = hipToFoot(ponto2) + footToHip(ponto1) + [0]*6
		mat.data[11] = mat.data[11]*-1	
		'''mat.data[7] = mat.data[7]*-1
		mat.data[2] = mat.data[2]*-1	
		mat.data[8] = mat.data[8]*-1'''
		pub.publish(mat)
		time = (time + 1)%nEstados
		print(mat.data)
		if time == 0:
			#print('time=0')
			flag = not flag
		rospy.sleep(tempoPasso/nEstados)


if __name__ == '__main__':
	try:
		talker()
	except rospy.ROSInterruptException:
		pass
