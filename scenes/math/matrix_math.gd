class_name MatrixMath extends Node
## Class with some static functions for matrix math.


static func zero_matrix(nX, nY):
	var matrix = []
	for x in range(nX):
		matrix.append([])
		for y in range(nY):
			matrix[x].append(0)
	return matrix


## Multiplies two matrices together.
static func matrix_multiply(a, b):
	var matrix = zero_matrix(a.size(), b[0].size())
	
	for i in range(a.size()):
		for j in range(b[0].size()):
			for k in range(a[0].size()):
				matrix[i][j] = matrix[i][j] + a[i][k] * b[k][j]
	return matrix
