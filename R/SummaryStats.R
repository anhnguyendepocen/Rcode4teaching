
#' Calculate the unfolded site-frequency spectrum
#' @param d A simulated data set
#' @export
sfs = function(d)
{
	s = array(data=0,dim=nrow(d$types)-1)
	S = length(d$pos)
	if(S==0)
	{
		return (s)
	}
	for(i in 1:S)
	{
		nmuts = length(d$types[,i][d$types[,i]==1])
		s[nmuts] = s[nmuts]+1
	}
	return(s)
}

#' Watterson's theta
#' @param d A simulated data set
#' @export
thetaw = function(d)
{
	nsam = nrow(d$types)
	S = length(d$pos)
	if(S==0){ return (0) }
	#factor of 2 here is b/c our an function above is in units of 2N generations
	return( 2*S/(an(nsam)) )
}

#' Calculate pi as sum of site heterozygosity
#' @param d A simulated data set
#' @export
pi = function(d)
{
	if(length(d$pos)==0) { return(0) }
	pq=0
	nsam = nrow(d$types)
	for(i in 1:ncol(d$types))
	{
		nmuts = length(d$types[,i][d$types[,i]==1])
		pq = pq + nmuts*(nsam-nmuts)
	}
	return ((2*pq)/(nsam*(nsam-1)))
}

#' Fay and Wu's ThetaH
#' @param d A simulated data set
#' @export
thetah = function(d)
{
	if(length(d$pos)==0) { return(0) }
	H=0
	for(i in 1:ncol(d$types))
	{
		nc = length(d$types[,i][d$types[,i]==1])
		H = H + (nc*nc)
	}
	nsam = nrow(d$types)
	return (2*H/(nsam*(nsam-1)))
}

#' A component of Tajima's D
#' @param n The sample size
#' @note Used internally
bn = function(n)
{
	b=0
	for(i in 1:n)
	{
		b = b+1/(i^2)
	}
	return (b)
}

#' Denominator of Tajima's D
#' @param S The number of segregating sites
#' @param n The sample size
TajdDdenominator = function(S,n)
{
	a = an(n)/2;
	b = bn(n)

	b1 = (n+1)/(3*(n-1))
	b2 = (2*(n^2) + n + 3)/(9*n*(n-1))
	c1 = b1-1/a
	c2 = b2 - (n+2)/(a*n) + b/(a^2)
	e1 = c1/a
	e2 = c1/(a^2 + b)
	return ( sqrt(e1*S + e2*S*(S-1)) )
}

#' Tajima's D
#' @param d A simulated data set
#' @export
TajD = function(d)
{
	if( length(d$pos) == 0 )
	{
		#return an undefined value if there are no segregating sites
		return(0/0)
	}
	return ( (pi(d)-thetaw(d))/TajdDdenominator(length(d$pos),nrow(d$types)) )
}

#' calculate the number of haplotypes (unique sequences) in the sample
#' @param d A simulated data set
#' @export
Nhaps = function(d)
{
	if( length(d$pos) == 0 ){ return(1) }
	return( nrow(unique(as.data.frame(d$types))) )
}
