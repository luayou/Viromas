# Viromas

Este documento presenta una guía para el análisis de secuencias provenientes del estudio de viromas intestinales. Este protocolo fue seguido para la realización del estudio "Fecal Virome of Healthy and Diarrheic Neonatal Calves" que fue financiado por el Departamento de Patobiología de Universidad de Guelph, en Guelph, Canadá, el grupo Tandem del Max Planck en Biología Computacional de la Universidad de los Andres, en Bogotá D.C., Colombia y por la Convocatoria Nacional de jóvenes investigadores e innovadores 2018, realizada por Colciencias. 

## Tipo de lecturas

Las lecturas usadas en este estudio fueron obtenidas a partir de la secuenciación de librerías de ADN proveninte de viromas intestinales bovinos, dichas librerías fueron realiazadas con el kit Nextera XT y secunciadas usando la plataforma de MiSeq Illumina con lecturas pareadas de 300 pb. 

## Información importante sobre los scripts

Gran parte de este trabajo se realizó haciendo uso del servicio de computo HPC de la Universidad de los Andes, por lo que los scripts aqui usados están escritos para ser interpretado por el manejador de trabajos TORQUE. Vale la pena resaltar que estos scripts pueden ser modificados para ser usados con cualquier otro sistema de colas y/o para modificar los parámetros dados a cada software. Para mayor claridad todos los scripts están escritos entre comillas. 

## Control de calidad de las secuencias

Para evitar sesgos por posibles errores de secuención, es necesario realizar un filtro de calidad de las secuencias. Para esto se realizan tres pasos. El primer paso se realiza usando FastQc, en donde se realiza un control de calidad de las secuencias y se definen los parámetros de calidad que se desean con base en la calidad mismas. Seguido, se utiliza Trimmomatic para limpiar las secuencias. Finalmente, volvemos a usar FastQc para verificar la limpieza de las secuencias. Los scripts utilizados fueron "runFastqc.sh", "trimmomatic.sh" y "runFastqc2.sh", respectivamente. 

## Remoción de lecturas provenientes del ADN del hóspedero

Con el fin de remover todos las lecturas contaminantes del ADN del hóspedero, se debe descargar todos los genomas del hospedero desde NCBI (En este caso puntual nosotros descargamos todos los genomas de la familia Bovidae almacenados en NCBI y concatenados en un solo archivo titulado bovidae.fna). Posteriormente, se mapean todos los reads usando FR-HIT a estos genoma y aquellos que mapean con un porcentaje de identidad mayor al 90% son removidos de cada archivo usando el script de filter_fasta.py de qiime. Estos pasos se realizan usando el script "removeReadsBovidae.sh".

## Ensamblaje y selección de contigs con longitud mayor a 500 pb. 

Para realizar el ensamblaje de las secuencias se utiliza IDBA_UD seguido de CAP3. IDBA_UD requiere que se tenga un solo archivo con las lecturas pareadas de manera intercalada para ensamblar. Para esto estos pasos, se utilizan los scripts "ibdamerge.sh" y "ibdamerge.sh", respectivamente. Una vez se obtienen todos los contigs, se agrupan con base en su porcentaje de indentidad para disminuir la redundancia genética de los mismos, este paso utiliza CD-HIt y se hace mediante el script "cdhitFrhitSet7.sh". Finalmente, se corre el script "seq_length.py" para determinar la longitud de cada contig y se usa el comando awk y el script filter_fasta.py de qiime para quedarse únicamente con los contigs con una longitud mayor a 500 pb. 

## Construcción de las matrices de abundancia 

Para realizar esto se deben mapear todas las lecturas a los contigs generados en el paso anterior, esto se hace usando FR-HIT y es una de las lineas del script "cdhitFrhitSet7.sh". El archivo de salida de este script es cargado en R mediante el script "obtainContigsMatrix.R", el cual realiza un filtro; removiendo todos los contigs que tengan una abundancia relativa menos a 0.01% en al menos una muestra.  

## Análisis de alpha y beta diversidad

Para realizar este análisis se utilizó la librería Vegan de R. Como entrada se utilizó el archivo de salidad del punto anterior y se corrier

