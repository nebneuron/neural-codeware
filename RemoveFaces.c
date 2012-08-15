#include <math.h>
#include "mex.h"
#include <stdio.h>

#if !defined(FALSE)
#define FALSE (0)
#endif

#if !defined(TRUE)
#define TRUE (!FALSE)
#endif

void CheckArguments(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* Ensure that an appropriate number of arguments were provided and that an
     * an appropriate number of return variables were requested. */
    if (nrhs != 2)
        mexErrMsgTxt("Exactly two input arguments are required.");
    else if (nlhs > 1)
        mexErrMsgTxt("Too many output arguments were requested.");
    
    /* Perform size- and type-checking on the input values. */
    if (!mxIsNumeric(prhs[0]) || mxIsComplex(prhs[0]))
        mexErrMsgTxt("The first argument must be an real-valued matrix.");
    else if (!mxIsNumeric(prhs[1]) || mxIsComplex(prhs[1]))
        mexErrMsgTxt("The second argument must be an real-valued matrix.");
    else if (mxGetN(prhs[0]) != mxGetN(prhs[1]))
        mexErrMsgTxt("Both arguments must have the same number of columns.");
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* Ensure that we have a valid set of arguments. */
    CheckArguments(nlhs, plhs, nrhs, prhs);
    
    /* Miscellaneous variable declarations. */
    mwIndex i, j, k, idx;
    
    /* Retrieve the first argument and get its size. */
    const mxArray* ptrFaceMatrix = prhs[0];
    double* ptrFaceMatrixData = mxGetPr(ptrFaceMatrix);
    mwSize iNumFaces = mxGetM(ptrFaceMatrix);
    mwSize iCols = mxGetN(ptrFaceMatrix);
    
    /* Retrieve the second argument and get its number of rows. */
    const mxArray* ptrEmptyFaceMatrix = prhs[1];
    double* ptrEmptyFaceMatrixData = mxGetPr(ptrEmptyFaceMatrix);
    mwSize iNumEmptyFaces = mxGetM(ptrEmptyFaceMatrix);
    
    /* These variables help us keep track of which faces need to be
     * kept/removed. */
    mwSize iNumRemainingFaces = 0;
    mxArray* ptrArrRemainingFaces = mxCreateLogicalMatrix(iNumFaces, 1);
    mxLogical* ptrArrRemainingFacesData = mxGetLogicals(ptrArrRemainingFaces);
    int bContainsAnEmpty, bContainsThisEmpty;
    
    /* Declare the return variable and the pointer to its data.  We
     * also want to keep track of how many faces have already been
     * places into this matrix. */
    mxArray* ptrRemainingFacesMatrix;
    double* ptrRemainingFacesMatrixData;
    int iNumAlreadyIncluded = 0;
    
    /* Loop through the faces of the complex to determine which faces
     * are in the Helly completion. */
    for (i = 0; i < iNumFaces; i++)
    {
        bContainsAnEmpty = FALSE;
        j = 0;
        
        /* Loop through the empty faces, but only check as many of
         * them as needed. */
        while (!bContainsAnEmpty && j < iNumEmptyFaces)
        {
            bContainsThisEmpty = TRUE;
            k = 0;
            
            /* Check whether this empty face is contained in this face
             * of the complex by looping through the number of columns
             * and comparing entries of the faces. */
            while (bContainsThisEmpty && k < iCols)
            {
                if (ptrEmptyFaceMatrixData[j + k * iNumEmptyFaces] == 1 &&
                    ptrFaceMatrixData[i + k * iNumFaces] != 1)
                {
                    bContainsThisEmpty = FALSE;
                }
                
                k++;
            }
            
            bContainsAnEmpty = bContainsThisEmpty;
            j++;
        }
        
        ptrArrRemainingFacesData[i] = !bContainsAnEmpty;
        
        if (!bContainsAnEmpty)
            iNumRemainingFaces++;
    }
    
    /* Allocate memory for the matrix of faces in the Helly completion. */
    ptrRemainingFacesMatrix = mxCreateDoubleMatrix(iNumRemainingFaces, iCols, mxREAL);
    ptrRemainingFacesMatrixData = mxGetPr(ptrRemainingFacesMatrix);
    
    for (i = 0; i < iNumFaces; i++)
        if (ptrArrRemainingFacesData[i])
        {
            for (j = 0; j < iCols; j++)
            {
                ptrRemainingFacesMatrixData[iNumAlreadyIncluded + j * iNumRemainingFaces] =
                    ptrFaceMatrixData[i + j * iNumFaces];
            }
        
            iNumAlreadyIncluded++;
        }
    
    /* Return the matrix of faces that remain after removal of empty
     * faces. */
    plhs[0] = ptrRemainingFacesMatrix;
    
    return;
}
