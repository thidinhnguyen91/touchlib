// Filter description
// ŻŻŻŻŻŻŻŻŻŻŻŻŻŻŻŻŻŻ
// Name: Barrel Distortion Correction Filter
// Purpose: Correcting the barrel distortion of the lens
// Original author: Laurence Muller (aka Falcon4ever)

/*
Tool url:
http://www.multigesture.net/wp-content/uploads/2007/12/touchlib_barreldistortion_tool.zip

example of usage:
<barreldistortioncorrection label="barreldistortioncorrection1">
    <border_size value="20" />
</barreldistortioncorrection>

Place the camera.yml (created by the calibration tool) in the same directory as the config.xml
*/

#include <BarrelDistortionCorrectionFilter.h>

BarrelDistortionCorrectionFilter::BarrelDistortionCorrectionFilter(char* s) : Filter(s)
{	
	CvFileNode *node;
	const char* configfile = "camera.yml";

	CvFileStorage *fs = cvOpenFileStorage( configfile, 0, CV_STORAGE_READ );

	node = cvGetFileNodeByName (fs, NULL, "camera_matrix");
	camera = (CvMat *) cvRead (fs, node);
	node = cvGetFileNodeByName (fs, NULL, "distortion_coefficients");
	dist_coeffs = (CvMat *) cvRead (fs, node);

	cvReleaseFileStorage (&fs);

	border_size = 0;	
}

BarrelDistortionCorrectionFilter::~BarrelDistortionCorrectionFilter()
{
	
}

void BarrelDistortionCorrectionFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("border_size")] = toString(border_size);	
}

void BarrelDistortionCorrectionFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "border_size") == 0)
	{
		border_size = (int) atof(value);		
	}
}

void BarrelDistortionCorrectionFilter::kernel()
{    
    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, source->nChannels);
        destination->origin = source->origin;  // same vertical flip as source
    }
 	
	if(border_size>0)
		destination = undistorted_with_border( source, camera, dist_coeffs, border_size );
	else
		cvUndistort2( source, destination, camera, dist_coeffs );	
}

IplImage*  BarrelDistortionCorrectionFilter::undistorted_with_border( const IplImage *image, const CvMat *intrinsic,const CvMat *distortion, short int border )
{
    assert( image );
    assert( intrinsic && distortion );
    assert( border >= 0 );

    //add border to cx,cy
    CvMat *b_intrinsic = cvCloneMat( intrinsic );
    cvSetReal2D( b_intrinsic, 0,2, cvGetReal2D(b_intrinsic,0,2)+border );
    cvSetReal2D( b_intrinsic, 1,2, cvGetReal2D(b_intrinsic,1,2)+border );

    //add border to image
    IplImage *bordered = cvCreateImage( cvSize(image->width+2*border,image->height+2*border), image->depth, image->nChannels );
    cvCopyMakeBorder( image, bordered, cvPoint(border,border), IPL_BORDER_CONSTANT, cvScalarAll(0) );

    //undistort
    IplImage *bordered_corr = cvCreateImage( cvSize(image->width+2*border,image->height+2*border), image->depth, image->nChannels );
    cvUndistort2( bordered, bordered_corr, b_intrinsic, distortion );

    cvReleaseImage( &bordered );
    return bordered_corr;

}