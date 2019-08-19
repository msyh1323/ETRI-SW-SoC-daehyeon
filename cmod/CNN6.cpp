#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <math.h>

using namespace cv;
using namespace std;

double ***convolution(double ***image, double ****FF, int S,int FR, int FC, int P, int CH, int depth, int img_size, double *bias);
double ***pooling(double ***image, int FR, int FC, int S, int depth, int img_size);
double *activation(double *sigma,int size);
double *fully_connected1(double ***pool,double **FF, int FR, int FC, int pool_CH, int pool_size, double *bias);
double *pully_connected2(double *fc1,double **FF,int rows,int cols,double *bias);
double *softmax(double *input, int input_len);


int main(){
    Mat image;
    image = imread("/home/socmgr/kdh/caffe/examples/mnist/image/99.jpg", IMREAD_GRAYSCALE);
    double ***image1;
    image1 = (double***)malloc(1*sizeof(double**));
    for(int i=0; i<1; i++){
        *(image1+i) = (double**)malloc(28*sizeof(double*));
        for(int j=0; j<28; j++){
            *(*(image1+i)+j) = (double*)malloc(28*sizeof(double));
        }
    }
    for(int j=0; j<1; j++){
        for(int k=0; k<image.rows; k++){
            for(int l=0; l<image.cols; l++){
                image1[j][k][l] = 255 - image.at<uchar>(k,l);
            }
        }
    }

    if(image.empty())
	{
		cout << "Could not open of find the image" << endl;
		return -1;
	}
    
    ////////////////////////////////////////////////////////////////////////////////
    FILE *fp1;
    fp1 = fopen("/home/socmgr/kdh/caffe/python/weights/conv1.txt","r");
    char words1;
    int n1[4];
    for(int i=0; i<11; i++){
        fscanf(fp1,"%c",&words1);
        //printf("%s ",words1);
    }
    fscanf(fp1,"%d",&n1[0]);
    printf("%d ",n1[0]);
    fscanf(fp1,"%c",&words1);
    fscanf(fp1,"%d",&n1[1]);
    printf("%d ",n1[1]);
    fscanf(fp1,"%c",&words1);
    fscanf(fp1,"%d",&n1[2]);
    printf("%d ",n1[2]);
    fscanf(fp1,"%c",&words1);
    fscanf(fp1,"%d",&n1[3]);
    printf("%d ",n1[3]);
    printf("\n");
    for(int i=0; i<15; i++){
        fscanf(fp1,"%c",&words1);
        //printf("%c ",words1);
    }

    double ****filter1;
    filter1 = (double****)malloc(n1[0]*sizeof(double***));
    for(int i=0; i<n1[0]; i++){
        *(filter1+i) = (double***)malloc(n1[2]*sizeof(double**));
        for(int j=0; j<n1[2]; j++){
            *(*(filter1+i)+j) = (double**)malloc(n1[3]*sizeof(double*));
            for(int k=0; k<n1[3]; k++){
                *(*(*(filter1+i)+j)+k) = (double*)malloc(n1[4]*sizeof(double));
            }
        }
    }
    for(int i=0; i<n1[0]; i++){
        for(int j=0; j<n1[1]; j++){
            for(int k=0; k<n1[2]; k++){
                for(int l=0; l<n1[3]; l++){
                    fscanf(fp1,"%lf",&filter1[i][j][k][l]);
                    //printf("%.10lf ",filter1[i][j][k][l]);
                    fscanf(fp1,"%c",&words1);
                }
                //printf("\n");
                fscanf(fp1,"%c",&words1);
                fscanf(fp1,"%c",&words1);
                fscanf(fp1,"%c",&words1);
            }
            //printf("\n");printf("\n");
            fscanf(fp1,"%c",&words1);
            fscanf(fp1,"%c",&words1);
            fscanf(fp1,"%c",&words1);
            fscanf(fp1,"%c",&words1);
        }
        //printf("\n");printf("\n");printf("\n");
    }

    fclose(fp1);

    FILE *fp11;
    fp11 = fopen("/home/socmgr/kdh/caffe/python/weights/conv1_b.txt","r");
    int n11;
    
    for(int i=0; i<11; i++){
        fscanf(fp11,"%c",&words1);
        //printf("%s ",words1);
    }
    fscanf(fp11,"%d",&n11);
    printf("%d\n",n11);
    
    for(int i=0; i<12; i++){
        fscanf(fp11,"%c",&words1);
        //printf("%c ",words1);
    }

    double *bias1;
    bias1 = (double*)malloc(n11*sizeof(double));
    
    for(int i=0; i<n11; i++){
        fscanf(fp11,"%lf",&bias1[i]);
        fscanf(fp11,"%c",&words1);
        //printf("%lf\n ",bias1[i]);
    }

    fclose(fp11);


    double ***conv1,***pool1;
    conv1 = convolution(image1, filter1, 1, n1[2], n1[3], 0, n1[1], n1[0], 28, bias1);
    int img_size1 = 28-5+1;
    pool1 = pooling(conv1, 2, 2, 2, n1[0], img_size1);

    ////////////////////////////////////////////////////////////////////////////////
    FILE *fp2;
    fp2 = fopen("/home/socmgr/kdh/caffe/python/weights/conv2.txt","r");
    char words2;
    int n2[4];
    for(int i=0; i<11; i++){
        fscanf(fp2,"%c",&words2);
        //printf("%s ",words1);
    }
    fscanf(fp2,"%d",&n2[0]);
    printf("%d ",n2[0]);
    fscanf(fp2,"%c",&words2);
    fscanf(fp2,"%d",&n2[1]);
    printf("%d ",n2[1]);
    fscanf(fp2,"%c",&words2);
    fscanf(fp2,"%d",&n2[2]);
    printf("%d ",n2[2]);
    fscanf(fp2,"%c",&words2);
    fscanf(fp2,"%d",&n2[3]);
    printf("%d ",n2[3]);
    printf("\n");
    for(int i=0; i<15; i++){
        fscanf(fp2,"%c",&words2);
        //printf("%s ",words1);
    }

    double ****filter2;
    filter2 = (double****)malloc(n2[0]*sizeof(double***));
    for(int i=0; i<n2[0]; i++){
        *(filter2+i) = (double***)malloc(n2[1]*sizeof(double**));
        for(int j=0; j<n2[1]; j++){
            *(*(filter2+i)+j) = (double**)malloc(n2[2]*sizeof(double*));
            for(int k=0; k<n2[2]; k++){
                *(*(*(filter2+i)+j)+k) = (double*)malloc(n2[3]*sizeof(double));
            }
        }
    }
    
    for(int i=0; i<n2[0]; i++){
        for(int j=0; j<n2[1]; j++){
            for(int k=0; k<n2[2]; k++){
                for(int l=0; l<n2[3]; l++){
                    
                    fscanf(fp2,"%lf",&filter2[i][j][k][l]);
                    //printf("%.10lf ",filter2[i][j][k][l]);
                    fscanf(fp2,"%c",&words2);
                }
                fscanf(fp2,"%c",&words2);
                fscanf(fp2,"%c",&words2);
                fscanf(fp2,"%c",&words2);
            }
            fscanf(fp2,"%c",&words2);
            fscanf(fp2,"%c",&words2);
            fscanf(fp2,"%c",&words2);
        }
        fscanf(fp2,"%c",&words2);
    }
    
    fclose(fp2);

    FILE *fp22;
    fp22 = fopen("/home/socmgr/kdh/caffe/python/weights/conv2_b.txt","r");
    int n22;
    
    for(int i=0; i<11; i++){
        fscanf(fp22,"%c",&words1);
        //printf("%s ",words1);
    }
    fscanf(fp22,"%d",&n22);
    printf("%d\n",n22);
    
    for(int i=0; i<12; i++){
        fscanf(fp22,"%c",&words2);
        //printf("%c ",words1);
    }

    double *bias2;
    bias2 = (double*)malloc(n22*sizeof(double));
    
    for(int i=0; i<n22; i++){
        fscanf(fp22,"%lf",&bias2[i]);
        fscanf(fp22,"%c",&words2);
        //printf("%lf\n ",bias2[i]);
    }

    fclose(fp22);

    double ***conv2,***pool2;
    int img_size2 = (img_size1-2)/2+1;
    
    conv2 = convolution(pool1, filter2, 1, n2[2], n2[3], 0, n2[1], n2[0], img_size2, bias2);
    int img_size3 = img_size2-5+1;
    pool2 = pooling(conv2, 2, 2, 2, n2[0], img_size3);
    
    
    /////////////////////////////////////////////////////

    FILE *fp3;
    fp3 = fopen("/home/socmgr/kdh/caffe/python/weights/ip1.txt","r");
    char words3;
    double **filter3;
    int n3[4];
    for(int i=0; i<11; i++){
        fscanf(fp3,"%c",&words3);
        //printf("%s ",words1);
    }
    fscanf(fp3,"%d",&n3[0]);
    printf("%d ",n3[0]);
    fscanf(fp3,"%c",&words3);
    fscanf(fp3,"%d",&n3[1]);
    printf("%d ",n3[1]);
    printf("\n");
    for(int i=0; i<13; i++){
        fscanf(fp3,"%c",&words3);
        //printf("%s ",words1);
    }

    filter3 = (double**)malloc(n3[0]*sizeof(double*));
    for(int i=0; i<n3[0]; i++){
        *(filter3+i) = (double*)malloc(n3[1]*sizeof(double));
    }

    for(int i=0; i<n3[0]; i++){
        for(int j=0; j<n3[1]; j++){
            fscanf(fp3,"%lf",&filter3[i][j]);
            fscanf(fp3,"%c",&words3);
        }
        fscanf(fp3,"%c",&words3);
        fscanf(fp3,"%c",&words3);
        fscanf(fp3,"%c",&words3);
    }
    
    // for(int i=0; i<500; i++){
    //     printf("%lf  \n",filter3[i][17]);
    // }
    


    fclose(fp3);

    FILE *fp33;
    fp33 = fopen("/home/socmgr/kdh/caffe/python/weights/ip1_b.txt","r");
    int n33;
    
    for(int i=0; i<11; i++){
        fscanf(fp33,"%c",&words1);
        //printf("%s ",words1);
    }
    fscanf(fp33,"%d",&n33);
    printf("%d\n",n33);
    
    for(int i=0; i<12; i++){
        fscanf(fp33,"%c",&words3);
        //printf("%c ",words1);
    }

    double *bias3;
    bias3 = (double*)malloc(n33*sizeof(double));
    
    for(int i=0; i<n33; i++){
        fscanf(fp33,"%lf",&bias3[i]);
        fscanf(fp33,"%c",&words3);
        //printf("%lf\n ",bias3[i]);
    }

    fclose(fp33);


    int img_size4 = (img_size3-2)/2+1;
    double *fc1,*act;
    fc1 = fully_connected1(pool2,filter3,n3[0],n3[1],n2[0],img_size4,bias3);
    act = activation(fc1,n3[0]);
/////////////////////////////////////////////////////////////////////

    FILE *fp4;
    fp4 = fopen("/home/socmgr/kdh/caffe/python/weights/ip2.txt","r");
    
    char words4;
    int n4[4];
    for(int i=0; i<11; i++){
        fscanf(fp4,"%c",&words4);
        //printf("%s ",words4);for(int i=0; i<800; i++){
    //     printf("%lf  ",filter3[499][i]);
    // }
    }
    fscanf(fp4,"%d",&n4[0]);
    printf("%d ",n4[0]);
    fscanf(fp4,"%c",&words4);
    fscanf(fp4,"%d",&n4[1]);
    printf("%d ",n4[1]);
    printf("\n");
    for(int i=0; i<13; i++){
        fscanf(fp4,"%c",&words4);
        //printf("%s ",words4);
    }
    double **filter4;
    filter4 = (double**)malloc(n4[0]*sizeof(double*));
    for(int i=0; i<n4[0]; i++){
        *(filter4+i) = (double*)malloc(n4[1]*sizeof(double));
    }

    for(int i=0; i<n4[0]; i++){
        for(int j=0; j<n4[1]; j++){
            fscanf(fp4,"%lf",&filter4[i][j]);
            // printf("%.10lf ",filter4[i][j]);
            fscanf(fp4,"%c",&words4);
        }
        fscanf(fp4,"%c",&words4);
        fscanf(fp4,"%c",&words4);
        fscanf(fp4,"%c",&words4);
    }
    
    fclose(fp4);

    FILE *fp44;
    fp44 = fopen("/home/socmgr/kdh/caffe/python/weights/ip2_b.txt","r");
    int n44;
    
    for(int i=0; i<11; i++){
        fscanf(fp44,"%c",&words4);
        //printf("%s ",words4);
    }
    fscanf(fp44,"%d",&n44);
    printf("%d\n",n44);
    
    for(int i=0; i<12; i++){
        fscanf(fp44,"%c",&words4);
        //printf("%c ",words1);
    }

    double *bias4;
    bias4 = (double*)malloc(n44*sizeof(double));
    
    for(int i=0; i<n44; i++){
        fscanf(fp44,"%lf",&bias4[i]);
        fscanf(fp44,"%c",&words4);
        //printf("%lf\n ",bias4[i]);
    }

    fclose(fp44);

    double *fc2;
    fc2 = (double*)malloc(n4[0]*sizeof(double));
    fc2 = pully_connected2(act,filter4,n4[0],n4[1],bias4);

//////////////////////////////////////////////////////////
    
    double *soft;
    soft = softmax(fc2,10);
    printf("\n");
    for(int i=0; i<10; i++){
        printf("%d : %lf\n",i,soft[i]);
    }
    
//    ////////////////////////////////////////////////////////////////////

//     free(fc2);

//     free(bias4);

    // for(int i=0; i<n4[0]; i++){
    //     free(*(filter4+i));
    // }
    // free(filter4);



    // free(act);
    // free(fc1);

    // free(bias3);

    // for(int i=0; i<n3[0]; i++){
    //     free(*(filter3+i));
    // }
    // free(filter3);

    // for(int i=0; i<50; i++){
    //     for(int j=0; j<img_size3; j++){
    //         free(*(*(pool2+i)+j));
    //     } 
    //     free(*(pool2+i));
    // }
    // free(pool2);

    // for(int i=0; i<50; i++){
    //     for(int j=0; j<8; j++){
    //         free(*(*(conv2+i)+j));
    //     } 
    //     free(*(conv2+i));
    // }
    // free(conv2);
    
    // free(bias2);

    // for(int i=0; i<n2[0]; i++){
    //     for(int j=0; j<n2[1]; j++){
    //         for(int k=0; k<n2[2]; k++){
    //             free(*(*(*(filter2+i)+j)+k));
    //         }
    //         free(*(*(filter2+i)+j));
    //     }
    //     free(*(filter2+i));
    // }
    // free(filter2);

    // for(int i=0; i<20; i++){
    //     for(int j=0; j<12; j++){
    //         free(*(*(pool1+i)+j));
    //     } 
    //     free(*(pool1+i));
    // }
    // free(pool1);

    // for(int i=0; i<20; i++){
    //     for(int j=0; j<24; j++){
    //         free(*(*(conv1+i)+j));
    //     } 
    //     free(*(conv1+i));
    // }
    // free(conv1);
    
    // free(bias1);

    // for(int i=0; i<n1[0]; i++){
    //     for(int j=0; j<n1[1]; j++){
    //         for(int k=0; k<n1[2]; k++){
    //             free(*(*(*(filter1+i)+j)+k));
    //         }
    //         free(*(*(filter1+i)+j));
    //     }
    //     free(*(filter1+i));
    // }
    // free(filter1);

    // for(int i=0; i<1; i++){
    //      for(int j=0; j<28; j++){
    //          free(*(*(image1+i)+j));
    //      } 
    //      free(*(image1+i));
    //  }
    //  free(image1);
    return 0;
}


double *softmax(double *input, int input_len){
   
    double m = -INFINITY;
    for(size_t i = 0; i<input_len; i++){
        if(input[i]>m){
            m = input[i];
        }
    }
    double exp_input[input_len] ={};
    for(int i=0; i<input_len; i++){
        exp_input[i] = exp(input[i]-m);
    }
    double sum_exp_input;
    for(int i=0; i<input_len; i++){
        sum_exp_input += exp_input[i]; 
    }
    double *y;
    y = (double*)malloc(input_len*sizeof(double));
    for(int i=0; i<input_len; i++){
        y[i] =(exp_input[i])/sum_exp_input;
    }
    return y;
}


double *fully_connected1(double ***pool,double **FF, int FR, int FC, int pool_CH, int pool_size, double *bias){
    double *fc;
    fc = (double*)malloc(FR*sizeof(double));
    double fff[FC];
    int count = 0;
    for(int i=0; i<FC; i++){
        fff[i] = 0;
    }

    for(int i=0; i<pool_CH; i++){
        for(int j=0; j<pool_size; j++){
            for(int k=0; k<pool_size; k++){
                fff[count] = pool[i][j][k];
                count++;
            }
        }
    }

    for(int i=0; i<FR; i++){
        for(int j=0; j<FC; j++){
            fc[i] += fff[j]*FF[i][j];
        }
        fc[i] += bias[i];
    }

    for(int i=0; i<FR; i++){
        if (isnan(fc[i])){
            fc[i]= 0;
        } 
    }
   
    return fc;
}
double *pully_connected2(double *fc1,double **FF,int rows,int cols, double *bias){
    double *fc;
    fc = (double*)malloc(rows*sizeof(double));

    for(int i=0; i<10; i++){
        fc[i] = 0;
    }
    
    for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
            if(fc1[j]!=0){
                fc[i] += fc1[j]*FF[i][j]; 
            }
        }
        fc[i] += bias[i];
    }

    return fc;
}


double ***convolution(double ***image, double ****FF, int S, int FR, int FC, int P, int CH, int depth, int img_size, double *bias){
    int C_rows = ((img_size-FR+2*P)/S)+1;
    int C_cols = ((img_size-FC+2*P)/S)+1;
    
    double ***conv;
    conv = (double***)malloc(depth*sizeof(double**));
    for(int i=0; i<depth; i++){
        *(conv+i) = (double**)malloc(C_rows*sizeof(double*));
        for(int j=0; j<C_rows; j++){
            *(*(conv+i)+j) = (double*)malloc(C_cols*sizeof(double));
        }
    }
    for(int i=0; i<depth; i++){
        for(int j=0; j<C_rows; j++){
            for(int k=0; k<C_cols; k++){
                conv[i][j][k] = 0;
            }
        }
    }
    
    for(int d=0; d<depth; d++){
        for(int j=0; j<C_rows; j++){
            for(int o=0; o<C_cols; o++){
                for(int i=0; i<CH; i++ ){
                    for(int k=0; k<FR; k++){
                        for(int l=0; l<FC; l++){
                            conv[d][j][o] += image[i][k+j*S][l+o*S]*FF[d][i][k][l];
                        }
                    }
                }    
                conv[d][j][o] += bias[d];    
            }
        }
    }
   
        // for(int j=0; j<C_rows; j++){
        //     for(int k=0; k<C_cols; k++){
        //         printf("%4.0lf",conv[0][j][k]);
        //     }
        //     printf("\n");
        // }


    return conv;
}



double ***pooling(double ***image, int FR, int FC, int S, int depth, int img_size){
    double img_size1 = ((img_size-FC)/S)+1;

    double ***max;
    max = (double***)malloc(depth*sizeof(double**));
    for(int i=0; i<depth; i++){
        *(max+i) = (double**)malloc(img_size1*sizeof(double*));
        for(int j=0; j<img_size1; j++){
            *(*(max+i)+j) = (double*)malloc(img_size1*sizeof(double));
        }
    }

    for(int i=0; i<depth; i++){
        for(int j=0; j<(((img_size-FR)/S)+1); j++){
            for(int k=0; k<(((img_size-FC)/S)+1); k++){
                max[i][k][k] = 0;
            }
        }
    }
    
    for(int d=0; d<depth; d++){
		for(int j=0; j<img_size1; j++){
			for(int k=0; k<img_size1; k++){
                max[d][j][k] = -INFINITY;
				for(int l=0; l<FR; l++){
                    for(int o=0; o<FC; o++){
                        if(max[d][j][k] < image[d][l+j*S][o+k*S]){
						    max[d][j][k] = image[d][l+j*S][o+k*S];
					    }                        
                    }
				}
		    }
		}
    }
    // for(int j=0; j<img_size1; j++){
    //         for(int k=0; k<img_size1; k++){
    //             printf("%4.0lf",max[0][j][k]);
    //         }
    //         printf("\n");
    //     }
	return max;
}




double *activation(double *sigma,int size){  
    for(int i=0; i<size; i++){
        if(sigma[i]<0){
			sigma[i] = 0;
        }
	}
    return sigma;
}
