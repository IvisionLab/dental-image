FCMTHRESH Thresholding by 3-class fuzzy c-means clustering
  [bw,level]=fcmthresh(IM,sw) outputs the binary image bw and threshold level of
  image IM using a 3-class fuzzy c-means clustering. It often works better
  than Otsu's methold which outputs larger or smaller threshold on
  fluorescence images.

  sw is 0 or 1, a switch of cut-off position.
  sw=0, cut between the small and middle class
  sw=1, cut between the middle and large class

Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
at Tsinghua University, Beijing, China.

Please try testfcmthresh.m first!