# kandidat1
För att komma igång med YALMIP (testat för Fedora, vet ej hur det funkar på Windows än):
1. starta matlab.
2. ställ dig där du vill installera
3. Kör följande kommandon (i Matlab)

urlwrite('https://github.com/yalmip/yalmip/archive/master.zip','yalmip.zip');

unzip('yalmip.zip','yalmip')

addpath(genpath([pwd filesep 'yalmip']));

savepath

4. Nu kan du testa installationen genom att köra yalmiptest.

För att konfigurera Yalmip inställningar se:
https://yalmip.github.io/command/sdpsettings/

Kända problem:
-Om du kör under linux/ios så kommer yalmip_addpath scriptet (hittat under yalmip_wilmer) inte att fungera. Kär yalmip_addpath_linux så bör det fungera.
- Ecosbinärerna verkar vara för windows och går inte att ladda ner/bygga utan registrering/licens. En workaround är att använda sdpsettings och välja bort ecos. 