wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/ldap-users/jyli/Documents/VSD_2017fall/workspace/sram_tb/tag_tb.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/tag_tb"
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tag_tb/clk} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tag_tb/clk} \
{/tag_tb/DO\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tag_tb/clk} \
{/tag_tb/DO\[31:0\]} \
{/tag_tb/A\[5:0\]} \
{/tag_tb/DI\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tag_tb/clk} \
{/tag_tb/DO\[31:0\]} \
{/tag_tb/A\[5:0\]} \
{/tag_tb/DI\[31:0\]} \
{/tag_tb/CS} \
{/tag_tb/OE} \
{/tag_tb/WEB\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 6 7 )} 
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalClose -win $_nWave1
wvZoom -win $_nWave1 1735.031211 129693.583021
wvSetCursor -win $_nWave1 9482.833661 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 20185.983438 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 11000.444451 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20745.103203 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 10121.827678 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 9642.582166 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 10601.073190 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 20185.983438 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 22502.336748 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 19786.612178 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 22102.965488 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 29770.893686 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 20265.857690 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 32167.121248 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 39755.175195 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 29850.767938 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 25138.187066 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 40074.672203 -snap {("G1" 1)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 21064.600211 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 22662.085252 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 11319.941459 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 30409.887703 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 29850.767938 -snap {("G1" 3)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 20345.731942 -snap {("G1" 4)}
wvZoom -win $_nWave1 30489.761955 33125.612273
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 0.000000 36390.262172
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 30166.209841 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 20000.000000
wvSetCursor -win $_nWave1 30575.089191
wvSetCursor -win $_nWave1 10040.259601 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20035.088162 -snap {("G1" 3)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 19898.795046 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 28985.002829 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 30438.796074 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 20080.519201 -snap {("G1" 3)}
wvZoom -win $_nWave1 29030.433868 32165.175553
wvSetCursor -win $_nWave1 30079.261298 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 30020.558270 -snap {("G1" 3)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 20037.300159 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 22166.263301 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 20663.465789 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 34313.876522 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 22604.579242 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 20851.315478 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 21915.797049 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 21602.714234 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 10957.898524 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 21477.481108 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 22354.112990 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 49341.851641 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 49905.400708 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 60362.366728 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49654.934456 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39761.517503 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 41076.465326 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 39886.750629 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39761.517503 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20287.766411 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 21540.097671 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 19912.067033 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20726.082352 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 20412.999537 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 19912.067033 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20851.315478 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 19912.067033 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 20350.382974 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 20788.698915 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 21414.864545 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 21790.563923 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 31057.815246 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 30055.950238 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 30932.582120 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 29993.333675 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 30869.965557 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 30055.950238 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 30932.582120 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 29868.100549 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 30744.732431 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 59798.817661 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 60612.832980 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 60925.915795 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 61552.081425 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 62616.562996 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 61301.615173 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 62366.096744 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 60800.682669 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 62178.247055 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 61364.231736 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 62553.946433 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 60111.900476 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 62553.946433 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 49780.167582 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 58922.185779 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 59924.050787 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 61489.464862 -snap {("G1" 6)}
wvSelectGroup -win $_nWave1 {G2}
wvSetCursor -win $_nWave1 71113.630595 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 70362.231839 -snap {("G1" 1)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 50112.035366 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 60255.918571 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 60569.001386 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 49861.569114 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 60193.302008 -snap {("G1" 1)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 50863.434122 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50926.050685 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50738.200996 -snap {("G1" 2)}
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 49341.851641 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 49467.084767 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 56104.440445 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 60487.599854 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 51596.047909 -snap {("G1" 7)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoom -win $_nWave1 45710.090987 54601.642933
wvSetCursor -win $_nWave1 51071.663509 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51016.160688 -snap {("G1" 2)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 50089.263575 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 51066.113227 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50977.308713 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51154.917740 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51021.710970 -snap {("G1" 2)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 49641.723221 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 48753.678083 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 49286.505166 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 48398.460028 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 49464.114194 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 50174.550304 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 50010.000000
wvSetCursor -win $_nWave1 44224.647879
wvSetCursor -win $_nWave1 40494.858298
wvSetCursor -win $_nWave1 39429.204133
wvSetCursor -win $_nWave1 39518.008647
wvSetCursor -win $_nWave1 39873.226702
wvSetCursor -win $_nWave1 39962.031216
wvSetCursor -win $_nWave1 50352.159332 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 49908.136763 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49641.723221 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 48664.873569 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49552.918707 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 40583.662812 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49819.332249 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39251.595105 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49552.918707 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39251.595105 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 30459.948238 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39695.617674 -snap {("G1" 1)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 50707.377387 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 49908.136762 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 39873.226702 -snap {("G1" 5)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 50263.354818 -snap {("G1" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetCursor -win $_nWave1 50085.745790 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 44313.452392 -snap {("G1" 2)}
wvZoom -win $_nWave1 49908.136762 50618.572873
wvSetCursor -win $_nWave1 50161.800592 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51036.852210 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51036.852210 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50981.862149 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 50174.682137 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 50047.850222 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50991.618450 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51021.330822 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 51380.983560 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49622.564186 -snap {("G1" 0)}
wvSetCursor -win $_nWave1 49601.277711
wvZoomAll -win $_nWave1
wvSetCursor -win $_nWave1 51143.071161
wvZoom -win $_nWave1 7868.164794 124169.475655
wvSetCursor -win $_nWave1 50845.927609 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 49829.561597 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 39448.108755 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 50700.732465 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 39375.511182 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 49829.561597 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 51136.317899 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 60428.807156 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 74875.724048 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 69721.296413 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 80247.944400 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 89758.226374 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 50265.147031 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50265.147031 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50773.330037 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 51063.720326 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 50555.537320 -snap {("G1" 2)}
