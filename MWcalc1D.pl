#!/usr/bin/perl
use Tk;


my @markerMW, @markerCM, @RFmarkerCM;
my $a, $b,$R2, $gelcm, $cm, $mw;

#Konstante i 'glob' promjenjljive
$e = 2.71828182845904;
@markerMW = (212, 118, 66, 43, 29, 20, 14);
$a = $b = $R2 = 1;
$mw = 0;
$b = 0;
$cm = 100;
$gelcm=200;

#-----------------------------------------------------------------------
#incijacija widget-a
$main = MainWindow->new();

$main->title("MWcalc1D 1.0");

$FrameLeft = $main->Frame (-width => 150, -height => 300);
$FrameCenter = $main->Frame (-width => 150, -height => 300);
$FrameRight = $main ->Frame(-width => 150, -height => 300);

#Sledeci kod RIJESAVA PROBLEM promjene geometrije prozora pri racunu

$frameL0 = $FrameLeft->Label(  -text => "                              ")->pack;
$frameC0 = $FrameCenter->Label(-text => "                                              ")->pack;
$frameR0 = $FrameRight-> Label(-text => "                                              ")->pack;

#Generisanje potrebnih winget-a (polja, dugmadi i sl.)
$label1L = $FrameLeft->Label(-text => "Gel Lenght");
$entry1C = $FrameCenter->Entry (-textvariable => \$gelcm);
$label1R = $FrameRight->Label(-text => "The distance to\nthe prot. line");

$label2L = $FrameLeft->Label(-text => "@markerMW[0]");
$entry2C = $FrameCenter->Entry (-textvariable => \@markerCM[0]);
$entry2R = $FrameRight->Entry(-textvariable => \$cm);

$label3L = $FrameLeft->Label(-text => "@markerMW[1]");
$entry3C = $FrameCenter->Entry (-textvariable => \@markerCM[1]);
$button3R = $FrameRight->Button(-text => 'Submit', -command => sub {racunaj();});

$label4L = $FrameLeft->Label(-text => "@markerMW[2]");
$entry4C = $FrameCenter->Entry (-textvariable => \@markerCM[2]);
$label4R = $FrameRight->Label(-text => $mw);

$label5L = $FrameLeft->Label(-text => "@markerMW[3]");
$entry5C = $FrameCenter->Entry (-textvariable => \@markerCM[3]);
$label5R = $FrameRight->Label(-text => 'y = ax+b');

$label6L = $FrameLeft->Label(-text => "@markerMW[4]");
$entry6C = $FrameCenter->Entry (-textvariable => \@markerCM[4]);
$label6R = $FrameRight->Label(-text => "a = $a");

$label7L = $FrameLeft->Label(-text => "@markerMW[5]");
$entry7C = $FrameCenter->Entry (-textvariable => \@markerCM[5]);
$label7R = $FrameRight->Label(-text => "b = $b");

$label8L = $FrameLeft->Label(-text => "@markerMW[6]");
$entry8C = $FrameCenter->Entry (-textvariable => \@markerCM[6]);
$label8R = $FrameRight->Label(-text => "R2 = $R2");

#opciono staviti dugme za Exit
#$button9R = $FrameRight->Button(-text => 'Exit', -command => sub {});


#Geometrijske funkcije elemenata prozora
$FrameLeft -> pack (-side => 'left');
$FrameCenter -> pack (-side => 'left');
$FrameRight -> pack (-side => 'left');

$label1L-> pack (-side => 'top');
$entry1C-> pack (-side => 'top');
$label1R-> pack (-side => 'top');

$label2L-> pack (-side => 'top', -pady => 1);
$entry2C-> pack (-side => 'top');
$entry2R-> pack (-side => 'top', -padx => 15);

$label3L-> pack (-side => 'top', -ipady => 2);
$entry3C-> pack (-side => 'top');
$button3R-> pack (-side => 'top');

$label4L-> pack (-side => 'top' , -ipady => 2);
$entry4C-> pack (-side => 'top');
$label4R-> pack (-side => 'top');

$label5L-> pack (-side => 'top', -ipady => 0);
$entry5C-> pack (-side => 'top');
$label5R-> pack (-side => 'top');

$label6L-> pack (-side => 'top', -pady =>1);
$entry6C-> pack (-side => 'top');
$label6R-> pack (-side => 'top');

$label7L-> pack (-side => 'top');
$entry7C-> pack (-side => 'top');
$label7R-> pack (-side => 'top');

$label8L-> pack (-side => 'top');
$entry8C-> pack (-side => 'top');
$label8R-> pack (-side => 'top');

$label4R->configure (-fg => '#A11818');

#POKRETANJE PROZORA
MainLoop();

#FUNKCIJE
#-----------------------------------------------------------------------

#funkcija za logaritmiranje svih clanova niza
sub LN_each_in_Aray {
  my @array, $n;
	$n = scalar @_;
	#print "$n:\n";	
	for (my $i = 0; $i<$n; $i++){
		print "unutar LN_each.. $i: @_[$i]\n"; 
		next if (@_[$i] == 0);
		@array[$i] = log (@_[$i]);
	}
	return @array;
}

#racunanje RF svakog clana niza (RF = duzina_do_markera / duzina_gela)
sub RF_each {
	my @array, $n;
	$n = scalar @_;
	for (my $i = 0; $i<$n; $i++){
		@array[$i] = @_[$i]/$gelcm;
	}
	return @array;
}

#funkcija uzima parametar x i racuna e^x
sub e_pow_N {
	my $n = $_[0];
	return $e ** $n;
}

#funkcija daje zbir svih clanova u nizu
sub sum { 
	my @arr, $summ;
	$summ = 0;
	@arr = @_;
	for (my $i = 0;$i<@arr; $i++){
		$summ += @arr[$i];
	}
	return $summ; 
}

#funkcija isjeca parametre niza u poljima gdje nisu uneseni
sub cut_null {#parametri (referenca, referenca)
	my $ref1, $ref2, @arr1, @arr2,@tmp1,@tmp2,$l1,$l2,$L;
	($ref1,$ref2) = @_;
	@arr1 = @{$ref1};
	@arr2 = @{$ref2};
	$l1 = @arr1;
	$l2 = @arr2;
	if ($l1 > $l2){
			$L = $l2;
	}
	else {$L = $l1;}
	for (my $i = 0; $i<$L; $i++){
		if (@arr1[$i]!=0 && @arr2[$i]!=0){ 
			@tmp1[$i] = @arr1[$i];
			@tmp2[$i] = @arr2[$i];
		}
	}
	@{$ref1} = @tmp1;
	@{$ref2} = @tmp2;		
}

#funkcija racuna trendline u obliku Y = aX + b
sub trend { 
			# argumenti su reference nizova
			# funkcija vraca vrijednosti a, b i r2 u nizu
	my @arrX, @arrY, $lX, $lY, $L;
	#varijable za kalkulaciju
	my $sumX, $sumY, $X2sum, $Y2sum, $sumXY, @temp;
	my $VAR, $DS, $covXY, $a, $b, $R, $R2;
	
	#iniciranje promjenljivih na vrijednost 0
	$sumX=$sumY=$X2sum=$Y2sum=$sumXY=$VAR=$DS=$covXY=$a=$b=$R=$R2 = 0;
	
	my ($ref1, $ref2) = @_;
	@arrX = @{$ref1};
	@arrY = @{$ref2};	
	
	#@arrX = @{$_[0]};#i ovo je ISPRAVNO
	#@arrY = @{$_[1]};# dodavanje nizova od referenci
	
	$lX = @arrX;
	$lY = @arrY;
		
	#Ograniciti u slucaju da su nizovi razliciti. Referentan je manji niz!
	if ($lX>$lY){
		$L = $lY;
	}
	else {$L = $lX;}
	
	$sumX = sum (@arrX);
	$sumY = sum (@arrY);
	
	$X2sum = $Y2sum = $sumXY = 0;
	
	for (my $i = 0; $i<$L; $i++){
					$X2sum += (@arrX[$i] ** 2);#kvadriranje
					$Y2sum += ((@arrY[$i])** 2);
					$sumXY += (@arrX[$i] * @arrY[$i]);
				}
	
	$VAR = ($X2sum - (($sumX**2)/$L)) / ($L-1);
	
	$covXY = ($sumXY - (($sumX*$sumY)/$L)) / ($L-1);
	
	$a = $covXY/$VAR;
	$b = ($sumY/$L) - (($sumX/$L)*$a);
	$R = $covXY / ($VAR * (($Y2sum - (($sumY**2)/$L)) / ($L-1)) )**(1/2);
	
	$R2 = $R**2;
	@temp = ($a, $b, $R2);	
	return @temp;
}
sub racunaj {
	my @markerMWtmp = @markerMW;#potrebno radi 'side effects' usled cun_null()
	my @markerCMtmp = @markerCM;
	cut_null (\@markerMWtmp,\@markerCMtmp);
	
	@markerMWlog = LN_each_in_Aray (@markerMWtmp);# ili po preporuci MR-Roti-Mark STANDARD
	#@markerMWlog = (5.3010 , 5.0755, 4.8195, 4.6335, 4.4624, 4.3010, 4.1613);#testirati!
	@RFmarkerCM = RF_each (@markerCMtmp);
	@RFmarkerCMlog = LN_each_in_Aray (@RFmarkerCM);
	print "----------------------------\n";
	print "markerMWlog: @markerMWlog\n";
	print "markerMWlog: @RFmarkerCMlog\n";
	($a,$b,$R2) = trend (\@markerMWlog, \@RFmarkerCMlog);
	print "a = $a, b = $b, r2 = $R2Glob\n";
	
	$cmRFlog = log($cm/$gelcm);
	
	$mw = (($cmRFlog)-$b)/$a;
	$mw = e_pow_N ($mw);	
	print "mw je $mw\n";
	print "KRAJ racunaj()\n";
	
	#Konfiguracija izlaza na prozoru
	$label4R->configure (-text => $mw);
	$label6R->configure (-text => "a = $a");
	$label7R->configure (-text => "b = $b");
	$label8R->configure (-text => "R2 = $R2");
}
