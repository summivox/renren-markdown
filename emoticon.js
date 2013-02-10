//from xiaonei-reformer
function addExtraEmotions(emjEmo,nEmo,bEmo,eEmo,fEmo,sfEmo,aEmo,odEmo) {
	var allEmo = {};

	// 状态表情列表
	var emList={
	//	":)":		{t:"开心",			s:"/imgpro/icons/statusface/1.gif"},
		"(微笑)":	{t:"微笑",			s:"/imgpro/icons/statusface/1.gif"},
		"@_@":		{t:"嘴唇",			s:"/imgpro/icons/statusface/2.gif"},
	//	"(k)":		{t:"嘴唇",			s:"/imgpro/icons/statusface/2.gif"},
		"(哭)":		{t:"哭",			s:"/imgpro/icons/statusface/3.gif"},
	//	":-O":		{t:"惊讶",			s:"/imgpro/icons/statusface/4.gif"},
		"(惊讶)":	{t:"惊讶",			s:"/imgpro/icons/statusface/4.gif"},
	//	":@":		{t:"生气",			s:"/imgpro/icons/statusface/5.gif"},
		"(生气)":	{t:"生气",			s:"/imgpro/icons/statusface/5.gif"},
	//	":(":		{t:"难过",			s:"/imgpro/icons/statusface/6.gif"},
		"(难过)":	{t:"难过",			s:"/imgpro/icons/statusface/6.gif"},
	//	":-p":		{t:"吐舌头",		s:"/imgpro/icons/statusface/7.gif"},
		"(l)":		{t:"爱",			s:"/imgpro/icons/statusface/8.gif"},
	//	"(v)":		{t:"花儿",			s:"/imgpro/icons/statusface/9.gif"},
		"(花)":		{t:"花儿",			s:"/imgpro/icons/statusface/9.gif"},
		"(ns)":		{t:"女生节",		s:"/imgpro/icons/statusface/10.gif"},
	//	"8-|":		{t:"书呆子",		s:"/imgpro/icons/statusface/13.gif"},
		"(书呆子)":	{t:"书呆子",		s:"/imgpro/icons/statusface/13.gif"},
	//	"|-)":		{t:"困",			s:"/imgpro/icons/statusface/14.gif"},
		"(困)":		{t:"困",			s:"/imgpro/icons/statusface/14.gif"},
		"(害羞)":	{t:"害羞",			s:"/imgpro/icons/statusface/15.gif"},
		"(大笑)":	{t:"大笑",			s:"/imgpro/icons/statusface/16.gif"},
	//	":d":		{t:"大笑",			s:"/imgpro/icons/statusface/16.gif"},
		"(口罩)":	{t:"防流感",		s:"/imgpro/icons/statusface/17.gif"},
		"(不)":		{t:"不",			s:"/imgpro/emotions/tie/1.gif"},
	//	"(奸笑)":	{t:"奸笑",			s:"/imgpro/emotions/tie/2.gif"},
		"(谄笑)":	{t:"谄笑",			s:"/imgpro/emotions/tie/2.gif"},
		"(吃饭)":	{t:"吃饭",			s:"/imgpro/emotions/tie/3.gif"},
	//	":-p":		{t:"吐舌头",		s:"/imgpro/emotions/tie/4.gif"},
		"(调皮)":	{t:"调皮",			s:"/imgpro/emotions/tie/4.gif"},
		"(尴尬)":	{t:"尴尬",			s:"/imgpro/emotions/tie/5.gif"},
		"(汗)":		{t:"汗",			s:"/imgpro/emotions/tie/6.gif"},
		"(惊恐)":	{t:"惊恐",			s:"/imgpro/emotions/tie/7.gif"},
		"(囧)":		{t:"囧-窘迫",		s:"/imgpro/emotions/tie/8.gif"},
		"(可爱)":	{t:"可爱",			s:"/imgpro/emotions/tie/9.gif"},
		"(酷)":		{t:"酷",			s:"/imgpro/emotions/tie/10.gif"},
		"(流口水)":	{t:"流口水",		s:"/imgpro/emotions/tie/11.gif"},
		"(猫猫笑)":	{t:"猫猫笑",		s:"/imgpro/emotions/tie/12.gif"},
		"(色)":		{t:"色迷迷",		s:"/imgpro/emotions/tie/13.gif"},
	//	"(病)":		{t:"生病",			s:"/imgpro/emotions/tie/14.gif"},
		"(生病)":	{t:"生病",			s:"/imgpro/emotions/tie/14.gif"},
		"(叹气)":	{t:"叹气",			s:"/imgpro/emotions/tie/15.gif"},
		"(淘气)":	{t:"淘气",			s:"/imgpro/emotions/tie/16.gif"},
		"(舔)":		{t:"舔",			s:"/imgpro/emotions/tie/17.gif"},
		"(偷笑)":	{t:"偷笑",			s:"/imgpro/emotions/tie/18.gif"},
		"(吐)":		{t:"呕吐",			s:"/imgpro/emotions/tie/19.gif"},
		"(吻)":		{t:"吻",			s:"/imgpro/emotions/tie/20.gif"},
		"(晕)":		{t:"晕",			s:"/imgpro/emotions/tie/21.gif"},
		"(住嘴)":	{t:"住嘴",			s:"/imgpro/emotions/tie/23.gif"},
		"(kb)":		{t:"抠鼻",			s:"/imgpro/icons/statusface/kbz2.gif"},
		"(sx)":		{t:"烧香",			s:"/imgpro/icons/statusface/shaoxiang.gif"},
		"(zmy)":	{t:"织毛衣",		s:"/imgpro/icons/statusface/zhimaoyi.gif"},
		"(jh)":		{t:"秋菊",			s:"/imgpro/icons/statusface/chrysanthemum.gif"},
		"(ju)":		{t:"人人聚焦",		s:"/imgpro/icons/statusface/jj.gif"},
		"(cold)":	{t:"降温",			s:"/imgpro/icons/statusface/cold.gif"},
		"(bw)":		{t:"暖暖被窝",		s:"/imgpro/icons/statusface/sleep.gif"},
		"(mb)":		{t:"膜拜",			s:"/imgpro/icons/statusface/guibai.gif"},
		"(tucao)":	{t:"吐槽",			s:"/imgpro/icons/statusface/tuc.gif"},
		"(s)":		{t:"大兵",			s:"/imgpro/icons/statusface/soldier.gif"},
		"(NBA)":	{t:"篮球",			s:"/imgpro/icons/statusface/basketball4.gif"},
		"(蜜蜂)":	{t:"小蜜蜂",		s:"/imgpro/icons/statusface/bee.gif"},
	//	"(bee)":	{t:"小蜜蜂",		s:"/imgpro/icons/statusface/bee.gif"},
		"(fl)":		{t:"花仙子",		s:"/imgpro/icons/statusface/hanago.gif"},
		"(cap)":	{t:"学位帽",		s:"/imgpro/icons/statusface/mortarboard.gif"},
		"(ice)":	{t:"冰棍儿",		s:"/imgpro/icons/statusface/ice-cream.gif"},
		"(冰棒)":	{t:"冰棒",			s:"/imgpro/icons/statusface/dbb.gif"},
		"(gs)":		{t:"园丁",			s:"/imgpro/icons/statusface/growing-sapling.gif"},
		"(ga)":		{t:"园丁",			s:"/imgpro/icons/statusface/gardener.gif"},
		"(光棍)":	{t:"光棍",			s:"/imgpro/icons/statusface/光棍.gif"},
		"(yt)":		{t:"光棍油条",		s:"/imgpro/icons/statusface/youtiao.gif"},
		"(bz)":		{t:"光棍包子",		s:"/imgpro/icons/statusface/baozi.gif"},
		"(wr)":		{t:"枯萎玫瑰",		s:"/imgpro/icons/statusface/wilt-rose.gif"},
		"(bh)":		{t:"破碎的心",		s:"/imgpro/icons/statusface/broken-heart.gif"},
		"(4)":		{t:"4周年",			s:"/imgpro/icons/statusface/4-years.gif"},
		"(cake)":	{t:"周年蛋糕",		s:"/imgpro/icons/statusface/4-birthday.gif"},
		"(ty)":		{t:"汤圆",			s:"/imgpro/icons/statusface/tang-yuan.gif"},
		"(read)":	{t:"读书日",		s:"/imgpro/icons/statusface/reading.gif"},
		"(ct)":		{t:"锄头",			s:"/imgpro/icons/statusface/chutou.gif"},
		"(bbt)":	{t:"棒棒糖",		s:"/imgpro/icons/statusface/bbt.gif"},
		"(bbg)":	{t:"棒棒糖",		s:"/imgpro/icons/statusface/bbg.gif"},
		"(bbl)":	{t:"棒棒糖",		s:"/imgpro/icons/statusface/bbl.gif"},
		"(xr)":		{t:"儿时回忆",		s:"/imgpro/icons/statusface/sm.gif"},
		"(mo)":		{t:"默哀",			s:"/imgpro/icons/statusface/lazhu.gif"},
		"(hot)":	{t:"烈日",			s:"/imgpro/icons/statusface/hot.gif"},
		"(feng)":	{t:"风扇",			s:"/imgpro/icons/statusface/fan.gif"},
		"(bb)":		{t:"便便",			s:"/imgpro/icons/statusface/shit.gif"},
		"(mg)":		{t:"七彩玫瑰",		s:"/imgpro/icons/statusface/rose.gif"},
		"(hzd)":	{t:"划重点",		s:"/imgpro/icons/statusface/huazhongdian.gif"},
		"(dm)":		{t:"点名",			s:"/imgpro/icons/statusface/dianming.gif"},
		"(hcn)":	{t:"花痴男",		s:"/imgpro/icons/statusface/hcn.gif"},
		"(hcv)":	{t:"花痴女",		s:"/imgpro/icons/statusface/hcnv.gif"},
		"(tic)":	{t:"车票",			s:"/imgpro/icons/statusface/ticket.gif"},
		"(tra)":	{t:"车头",			s:"/imgpro/icons/statusface/train.gif"},
		"(trb)":	{t:"车厢",			s:"/imgpro/icons/statusface/trainbox.gif"},
		"(bon)":	{t:"年终奖",		s:"/imgpro/icons/statusface/award.gif"},
		"(pt)":		{t:"派对，干杯",	s:"/imgpro/icons/statusface/partycup.gif"},
		"(三行情书)":{t:"三行情书",		s:"/imgpro/icons/statusface/xin.gif"},
		"(knx)":	{t:"康乃馨",		s:"/imgpro/icons/statusface/carnation.gif"},
		"(520)":	{t:"520",			s:"/imgpro/icons/statusface/heart.gif"},
		"(al)":		{t:"暗恋",			s:"/imgpro/icons/statusface/520.gif"},
		"(暗恋特权)":{t:"暗恋特权",		s:"/imgpro/icons/statusface/anlian.gif"},
		"(bby)":	{t:"小男孩",		s:"/imgpro/icons/statusface/boy2011.gif"},
		"(bgi)":	{t:"小女孩",		s:"/imgpro/icons/statusface/girl2011.gif"},
		"(bal)":	{t:"气球",			s:"/imgpro/icons/statusface/balloon.gif"},
		"(jy)":		{t:"加油",			s:"/imgpro/icons/statusface/2011gaokao.gif"},
		"(jt1)":	{t:"家庭空间",		s:"/imgpro/icons/statusface/jt1.gif"},
		"(jt2)":	{t:"家庭空间",		s:"/imgpro/icons/statusface/jt2.gif"},
		"(yb)":		{t:"元宝",			s:"/imgpro/icons/statusface/yuanbao.gif"},
		"(xx)":		{t:"星星",			s:"/imgpro/icons/statusface/xx.gif"},
		"(nz)":		{t:"奶嘴",			s:"/imgpro/icons/statusface/nz.gif"},
		"(石化)":	{t:"石化",			s:"/imgpro/icons/statusface/sh.gif"},
		"(哨子)":	{t:"哨子",			s:"/imgpro/icons/new-statusface/shaozi.gif"},
		"(fb)":		{t:"足球",			s:"/imgpro/icons/new-statusface/football.gif"},
		"(rc)":		{t:"红牌",			s:"/imgpro/icons/new-statusface/redCard.gif"},
		"(yc)":		{t:"黄牌",			s:"/imgpro/icons/new-statusface/yellowCard.gif"},
		"(^)":		{t:"蛋糕",			s:"/imgpro/icons/3years.gif"},
		"(r)":		{t:"火箭",			s:"/imgpro/icons/ico_rocket.gif"},
		"(w)":		{t:"宇航员",		s:"/imgpro/icons/ico_spacewalker.gif"},
		"(i)":		{t:"电灯泡",		s:"/img/ems/bulb.gif"},
		"(yeah)":	{t:"哦耶",			s:"/img/ems/yeah.gif"},
		"(good)":	{t:"牛",			s:"/img/ems/good.gif"},
		"(ng)":		{t:"否",			s:"/imgpro/icons/statusface/nogood.gif"},
		"(zy)":		{t:"最右",			s:"/imgpro/icons/statusface/zy.gif"},
		"(f)":		{t:"拳头",			s:"/img/ems/fist.gif"}
	};
	var nEmList={
		"(earth)":	{t:"地球",			s:"/imgpro/icons/statusface/wwf-earth.gif"},
		"(earth1)":	{t:"地球",			s:"/imgpro/icons/statusface/earth.gif"},
		"(rainy)":	{t:"雨",			s:"/imgpro/icons/statusface/rainy.gif"},
	//	"(rain)":	{t:"雨",			s:"/imgpro/icons/statusface/rainy.gif"},
		"(by)":		{t:"下雨",			s:"/imgpro/icons/statusface/rain.gif"},
		"(ly)":		{t:"落叶",			s:"/imgpro/icons/statusface/autumn-leaves.gif"},
		"(dx)":		{t:"雪人",			s:"/imgpro/icons/statusface/snowman.gif"},
		"(sn)":		{t:"雪花",			s:"/imgpro/icons/statusface/snow.gif"},
		"(fz)":		{t:"风筝",			s:"/imgpro/icons/statusface/kite.gif"},
		"(lt)":		{t:"柳枝",			s:"/imgpro/icons/statusface/willow.gif"},
		"(bs)":		{t:"秋高气爽",		s:"/imgpro/icons/statusface/bluesky.gif"},
		"(fog)":	{t:"大雾",			s:"/imgpro/icons/statusface/dawu.gif"},
		"(h)":		{t:"小草",			s:"/imgpro/icons/philips.jpg"},
	};
	var bEmList={
		"(gl)":		{t:"给力",			s:"/imgpro/icons/statusface/geili.gif"},
		"(bgl)":	{t:"不给力",		s:"/imgpro/icons/statusface/bugeili.gif"},
		"(ugl)":	{t:"不给力",		s:"/imgpro/icons/statusface/ungelivable.gif"},
		"(yl)":		{t:"鸭梨",			s:"/imgpro/icons/statusface/yali.gif"},
		"(dli)":	{t:"冻梨",			s:"/imgpro/icons/statusface/dl.gif"},
	//	"(hold)":	{t:"Hold住",		s:"/imgpro/icons/statusface/hold.gif"},
		"(hold1)":	{t:"Hold住",		s:"/imgpro/icons/statusface/holdzhu.gif"},
		"(sbq)":	{t:"伤不起",		s:"/imgpro/icons/statusface/shangbuqi.gif"},
		"(ymy)":	{t:"有木有",		s:"/imgpro/icons/statusface/youmuyou.gif"},
		"(th)":		{t:"惊叹号",		s:"/imgpro/icons/statusface/exclamation.gif"},
		"(cb)":		{t:"蟹蟹",			s:"/imgpro/icons/statusface/crab.gif"},
		"(see)":	{t:"看海",			s:"/imgpro/icons/statusface/seesea.gif"},
		"(禅师)":	{t:"禅师",			s:"/imgpro/icons/statusface/chsh.gif"},
		"(twg)":	{t:"style",			s:"/imgpro/icons/statusface/style.gif"},
		"(走你)":	{t:"走你",			s:"/imgpro/icons/statusface/zn.gif"},
		"(小黄鸡)":	{t:"小黄鸡",		s:"/imgpro/icons/statusface/xhj.gif"},
	};
	var eEmList={
		"(guoqing)":		{t:"国庆",		s:"/imgpro/icons/statusface/guoqing.gif"},
		"(gq)":		{t:"国庆快乐",		s:"/imgpro/icons/statusface/nationalday2010.gif"},
		"(gq2)":	{t:"国庆快乐",		s:"/imgpro/icons/statusface/national-day-balloon.gif"},
		"(gq3)":	{t:"我爱中国",		s:"/imgpro/icons/statusface/national-day-i-love-zh.gif"},
		"(元旦)":	{t:"元旦快乐",		s:"/imgpro/icons/statusface/gantan.gif"},
		"(dl)":		{t:"灯笼",			s:"/imgpro/icons/statusface/lantern.gif"},
		"(va)":		{t:"情人节",		s:"/imgpro/icons/statusface/qixi.gif"},
		"(qx)":		{t:"七夕",			s:"/imgpro/icons/statusface/qixi11.gif"},
		"(qx2)":	{t:"七夕",			s:"/imgpro/icons/statusface/qixi2.gif"},
		"(yrj)":	{t:"愚人节",		s:"/imgpro/icons/statusface/yrj.gif"},
		"(wy)":		{t:"劳动节",		s:"/imgpro/icons/statusface/wuyi.gif"},
		"(laodong)":{t:"五一",			s:"/imgpro/icons/statusface/5.1.gif"},
		"(cy1)":	{t:"重阳节",		s:"/imgpro/icons/statusface/09double9-3.gif"},
		"(cy2)":	{t:"登高",			s:"/imgpro/icons/statusface/09double9.gif"},
		"(cy3)":	{t:"饮菊酒",		s:"/imgpro/icons/statusface/09double9-2.gif"},
		"(dad)":	{t:"父亲节",		s:"/imgpro/icons/statusface/love-father.gif"},
		"(safe)":	{t:"感恩母亲",		s:"/imgpro/icons/statusface/safeguard.gif"},
		"(mom)":	{t:"母亲节",		s:"/imgpro/icons/statusface/ilovemom.gif"},
		"(ngd)":	{t:"南瓜灯",		s:"/imgpro/icons/statusface/pumpkin.gif"},
		"(xg)":		{t:"小鬼",			s:"/imgpro/icons/statusface/ghost.gif"},
		"(hh)":		{t:"圣诞花环",		s:"/imgpro/icons/statusface/garland.gif"},
		"(stick)":	{t:"拐杖糖",		s:"/imgpro/icons/statusface/stick.gif"},
		"(socks)":	{t:"圣诞袜",		s:"/imgpro/icons/statusface/stocking.gif"},
		"(xmas)":	{t:"圣诞老人",		s:"/imgpro/icons/statusface/xmas-man.gif"},
		"(ring)":	{t:"圣诞铃铛",		s:"/imgpro/icons/statusface/xmas-ring.gif"},
		"(tree)":	{t:"圣诞树",		s:"/imgpro/icons/statusface/xmas-tree.gif"},
		"(tk)":		{t:"火鸡",			s:"/imgpro/icons/statusface/turkey.gif"},
		"(nrj)":	{t:"女人节",		s:"/imgpro/icons/statusface/lipstick.gif"},
		"(zsj)":	{t:"植树节",		s:"/imgpro/icons/statusface/trees.gif"},
		"(rs)":		{t:"玫瑰花",		s:"/imgpro/icons/statusface/rose0314.gif"},
		"(315)":	{t:"消费者权益保护日",s:"/imgpro/icons/statusface/20110315.gif"},
		"(yb1)":	{t:"月饼",			s:"/imgpro/icons/statusface/mooncake.gif"},
		"(zz)":		{t:"粽子",			s:"/imgpro/icons/statusface/zongzi.gif"},
		"(lot)":	{t:"龙头",			s:"/imgpro/icons/statusface/dwj_longtou.gif"},
		"(huc)":	{t:"划船",			s:"/imgpro/icons/statusface/dwj_huachuan.gif"},
		"(dag)":	{t:"打鼓",			s:"/imgpro/icons/statusface/dwj_dagu.gif"},
		"(low)":	{t:"龙尾",			s:"/imgpro/icons/statusface/dwj_longwei.gif"},
		"(hjr)":	{t:"世界环境日",	s:"/imgpro/icons/statusface/earthday.gif"},
		"(eh)":		{t:"地球一小时",	s:"/imgpro/icons/statusface/onehour2011.gif"},
	//	"(虎年)":	{t:"虎年",			s:"/imgpro/icons/statusface/tiger.gif"},
		"(tiger)":	{t:"虎年",			s:"/imgpro/icons/statusface/tiger.gif"},
		"(ra1)":	{t:"拜年兔",		s:"/imgpro/icons/statusface/rabbit.gif"},
		"(ra2)":	{t:"拜年兔",		s:"/imgpro/icons/statusface/rabbit2.gif"},
		"(fu)":		{t:"福",			s:"/imgpro/icons/statusface/fu.gif"},
		"(boy)":	{t:"男孩",			s:"/imgpro/icons/statusface/boy.gif"},
		"(girl)":	{t:"女孩",			s:"/imgpro/icons/statusface/girl.gif"},
		"(eclipse)":{t:"日全食",		s:"/imgpro/icons/statusface/eclipse.gif"},
		"(gk)":		{t:"高考",			s:"/imgpro/icons/statusface/gaokao.gif"},
		"(gk3)":	{t:"高考",			s:"/imgpro/icons/statusface/gk.gif"},
		"(pass)":	{t:"CET必过",		s:"/imgpro/icons/statusface/cet46.gif"},
		"(qgz)":	{t:"人人求工作",	s:"/imgpro/icons/statusface/offer.gif"},
		"(南非)":	{t:"南非",			s:"/imgpro/icons/new-statusface/nanfei.gif"},
		"(kxl)":	{t:"开学啦",		s:"/imgpro/icons/statusface/kaixuela-wide.gif",w:true},
		"(kx)":		{t:"开学",			s:"/imgpro/icons/statusface/kx.gif"},
		"(jz)":		{t:"捐建小学",		s:"/imgpro/icons/statusface/grass.gif"},
		"(nasa)":	{t:"NASA",			s:"/imgpro/icons/statusface/nasa.gif"},
		"(hz)":		{t:"传递爱心",		s:"/imgpro/icons/statusface/cdax.gif"},
		"(jq)":		{t:"坚强",			s:"/imgpro/icons/statusface/quake.gif"},
		"(rr)":		{t:"红丝带",		s:"/imgpro/icons/statusface/red-ribbon.gif"},
		"(hsd)":	{t:"红丝带",		s:"/imgpro/icons/statusface/hsd.gif"},
		"(ny)":		{t:"新年好",		s:"/imgpro/icons/statusface/2011.gif"},
		"(lb)":		{t:"腊八粥",		s:"/imgpro/icons/statusface/laba.gif"},
		"(long1)":	{t:"龙1",			s:"/imgpro/icons/statusface/long1.gif"},
		"(long2)":	{t:"龙2",			s:"/imgpro/icons/statusface/long2.gif"},
		"(long3)":	{t:"龙3",			s:"/imgpro/icons/statusface/long3.gif"},
		"(long4)":	{t:"龙4",			s:"/imgpro/icons/statusface/long4.gif"},
		"(long5)":	{t:"龙5",			s:"/imgpro/icons/statusface/long5.gif"},
		"(long6)":	{t:"龙6",			s:"/imgpro/icons/statusface/long6.gif"},
		"(vdlove)":	{t:"爱就大声说",	s:"/imgpro/icons/statusface/vdlove.gif"},
		"(金牌)":	{t:"金牌",			s:"/imgpro/icons/statusface/金牌.gif"},
		"(银牌)":	{t:"银牌",			s:"/imgpro/icons/statusface/银牌.gif"},
		"(铜牌)":	{t:"铜牌",			s:"/imgpro/icons/statusface/铜牌.gif"},
		"(t)":		{t:"火炬",			s:"/img/ems/torch.gif"},
		"(hjl)":	{t:"火炬",			s:"/imgpro/icons/statusface/hx.gif"}
	};
	var fEmList={
		"(mj)":		{t:"迈克尔.杰克逊",	s:"/imgpro/icons/statusface/mj.gif"},
		"(mj2)":	{t:"迈克尔.杰克逊",	s:"/imgpro/icons/statusface/mj2.gif"},
		"(mj3)":	{t:"迈克尔.杰克逊",	s:"/imgpro/icons/statusface/mj3.gif"},
		"(qxs)":	{t:"悼念钱学森",	s:"/imgpro/icons/statusface/qianxuesen.gif"},
		"(raul)":	{t:"劳尔",			s:"/imgpro/icons/statusface/laoer.gif"},
		"(smlq)":	{t:"萨马兰奇",		s:"/imgpro/icons/statusface/samaranch2.gif"},
		"(kz)":		{t:"孔子",			s:"/imgpro/icons/statusface/kz.gif"},
		"(ta)":		{t:"博派",			s:"/imgpro/icons/statusface/Transformers-Autobot.gif"},
		"(td)":		{t:"狂派",			s:"/imgpro/icons/statusface/Transformers-Decepticon.gif"},
		"(jobs)":	{t:"乔布斯",		s:"/imgpro/icons/statusface/jobs.gif"},
	};
	var sfEmList={
		"(shafa1)":		{t:"抢沙发1",		s:"/imgpro/icons/statusface/rrdesk/kf.gif"},
	//	"(shafa2)":		{t:"抢沙发2",		s:"/imgpro/icons/statusface/rrdesk/kf.gif"},
		"(shafa3)":		{t:"抢沙发3",		s:"/imgpro/icons/statusface/rrdesk/gloves.gif"},
		"(shafa4)":		{t:"抢沙发4",		s:"/imgpro/icons/statusface/rrdesk/hat.gif"},
	//	"(shafa5)":		{t:"抢沙发5",		s:"/imgpro/icons/statusface/rrdesk/hat.gif"},
		"(shafa6)":		{t:"抢沙发6",		s:"/imgpro/icons/statusface/rrdesk/heart.gif"},
	//	"(shafa7)":		{t:"抢沙发7",		s:"/imgpro/icons/statusface/rrdesk/heart.gif"},
		"(shafa8)":		{t:"抢沙发8",		s:"/imgpro/icons/statusface/rrdesk/jiaoxi.gif"},
	//	"(shafa9)":		{t:"抢沙发9",		s:"/imgpro/icons/statusface/rrdesk/jiaoxi.gif"},
		"(shafa10)":	{t:"抢沙发10",		s:"/imgpro/icons/statusface/rrdesk/muffle.gif"},
		"(shafa11)":	{t:"抢沙发11",		s:"/imgpro/icons/statusface/rrdesk/sds.gif"},
	//	"(shafa12)":	{t:"抢沙发12",		s:"/imgpro/icons/statusface/rrdesk/sds.gif"},
		"(shafa13)":	{t:"抢沙发13",		s:"/imgpro/icons/statusface/rrdesk/snow.gif"},
		"(shafa14)":	{t:"抢沙发14",		s:"/imgpro/icons/statusface/rrdesk/sdlr.gif"},
	//	"(shafa15)":	{t:"抢沙发15",		s:"/imgpro/icons/statusface/rrdesk/sdlr.gif"},
		"(shafa16)":	{t:"抢沙发16",		s:"/imgpro/icons/statusface/rrdesk/mao.gif"},
	};

	var aEmList={
		"(bl)":		{t:"冰露",			s:"/imgpro/icons/statusface/ice.gif"},
		"(qt)":		{t:"蜻蜓",			s:"/imgpro/icons/statusface/qingt.gif"},
		"(zg)":		{t:"整蛊作战",		s:"/imgpro/icons/statusface/tomato.png"},
		"(abao)":	{t:"功夫熊猫",		s:"/imgpro/icons/statusface/panda.gif"},
		"(nuomi)":	{t:"糯米",			s:"/imgpro/icons/new-statusface/nuomi2.gif"},
	//	"(草莓)":	{t:"愉悦一刻 ",		s:"/imgpro/icons/statusface/mzy.gif"},
		"(愉悦一刻)":{t:"果粒奶优,愉悦一刻",s:"/imgpro/icons/statusface/mzynew.gif"},
		"(LG)":		{t:"LG棒棒糖",		s:"/imgpro/activity/lg-lolipop/faceicon_2.gif"},
		"(crm)":	{t:"Google Chrome",	s:"/imgpro/icons/statusface/chrome.gif"},
		"(360)":	{t:"360极速浏览器",	s:"/imgpro/icons/statusface/360chrome.gif"},
		"(fes)":	{t:"枫树浏览器",	s:"/imgpro/icons/statusface/chromeplus.gif"},
		"(camay)":	{t:"卡玫尔七夕",	s:"/imgpro/icons/statusface/camay.gif"},
		"(xrk)":	{t:"向日葵",		s:"/imgpro/icons/statusface/taiyang.gif"},
		"(wd)":		{t:"豌豆射手",		s:"/imgpro/icons/statusface/wandou.gif"},
		"(dou)":	{t:"豌豆",			s:"/imgpro/icons/statusface/dou.gif"},
		"(jqg)":	{t:"小坚果",		s:"/imgpro/icons/statusface/hetao.gif"},
		"(jsh)":	{t:"僵尸",			s:"/imgpro/icons/statusface/jiangshi.gif"},
	//	"(wd1)":	{t:"豌豆",			s:"/imgpro/icons/statusface/wandou1.gif"},	和(dou)图片相同
	//	"(js)":		{t:"僵尸",			s:"/imgpro/icons/statusface/jiangshi1.gif"},	和(jsh)图片相同
		"(69)":		{t:"翻转",			s:"/imgpro/icons/statusface/fanzhuan.gif"},
	};
	// 下面是内容过时的表情
	var odEmList={
		"(gq1)":	{t:"国庆六十周年",	s:"/imgpro/icons/statusface/national-day-60-firework.gif"},
		"(2011)":	{t:"2011",			s:"/imgpro/icons/statusface/2011g.gif"},
		"(five)":	{t:"人人网5周年",	s:"/imgpro/icons/statusface/5years.gif"},
		"(six)":	{t:"人人网6周年",	s:"/imgpro/icons/statusface/six.gif"},
		"(七周年)":	{t:"七周年",		s:"/imgpro/icons/statusface/7years.gif"},
		"(jd)":		{t:"建党90周年",	s:"/imgpro/icons/statusface/party90.gif"},
		"(2012)":	{t:"世界末日",		s:"/imgpro/icons/statusface/2012.gif"},
		"(qh)":		{t:"清华校庆",		s:"/imgpro/icons/statusface/tsinghua100.gif"},
	};

  // 按iOS给的顺序：http://punchdrunker.github.com/iOSEmoji/table_html/index.html
  var seq = [0xE415, 0xE056, 0xE057, 0xE414, 0xE405, 0xE106, 0xE418, 0xE417, 0xE40D, 0xE40A, 0xE404, 0xE105, 0xE409, 0xE40E, 0xE402, 0xE108, 0xE403, 0xE058, 0xE407, 0xE401, 0xE40F, 0xE40B, 0xE406, 0xE413, 0xE411, 0xE412, 0xE410, 0xE107, 0xE059, 0xE416, 0xE408, 0xE40C, 0xE11A, 0xE10C, 0xE32C, 0xE32A, 0xE32D, 0xE328, 0xE32B, 0xE022, 0xE023, 0xE327, 0xE329, 0xE32E, 0xE335, 0xE334, 0xE337, 0xE336, 0xE13C, 0xE330, 0xE331, 0xE326, 0xE03E, 0xE11D, 0xE05A, 0xE00E, 0xE421, 0xE420, 0xE00D, 0xE010, 0xE011, 0xE41E, 0xE012, 0xE422, 0xE22E, 0xE22F, 0xE231, 0xE230, 0xE427, 0xE41D, 0xE00F, 0xE41F, 0xE14C, 0xE201, 0xE115, 0xE428, 0xE51F, 0xE429, 0xE424, 0xE423, 0xE253, 0xE426, 0xE111, 0xE425, 0xE31E, 0xE31F, 0xE31D, 0xE001, 0xE002, 0xE005, 0xE004, 0xE51A, 0xE519, 0xE518, 0xE515, 0xE516, 0xE517, 0xE51B, 0xE152, 0xE04E, 0xE51C, 0xE51E, 0xE11C, 0xE536, 0xE003, 0xE41C, 0xE41B, 0xE419, 0xE41A, 0xE04A, 0xE04B, 0xE049, 0xE048, 0xE04C, 0xE13D, 0xE443, 0xE43E, 0xE04F, 0xE052, 0xE053, 0xE524, 0xE52C, 0xE52A, 0xE531, 0xE050, 0xE527, 0xE051, 0xE10B, 0xE52B, 0xE52F, 0xE109, 0xE528, 0xE01A, 0xE134, 0xE530, 0xE529, 0xE526, 0xE52D, 0xE521, 0xE523, 0xE52E, 0xE055, 0xE525, 0xE10A, 0xE522, 0xE019, 0xE054, 0xE520, 0xE306, 0xE030, 0xE304, 0xE110, 0xE032, 0xE305, 0xE303, 0xE118, 0xE447, 0xE119, 0xE307, 0xE308, 0xE444, 0xE441, 0xE436, 0xE437, 0xE438, 0xE43A, 0xE439, 0xE43B, 0xE117, 0xE440, 0xE442, 0xE446, 0xE445, 0xE11B, 0xE448, 0xE033, 0xE112, 0xE325, 0xE312, 0xE310, 0xE126, 0xE127, 0xE008, 0xE03D, 0xE00C, 0xE12A, 0xE00A, 0xE00B, 0xE009, 0xE316, 0xE129, 0xE141, 0xE142, 0xE317, 0xE128, 0xE14B, 0xE211, 0xE114, 0xE145, 0xE144, 0xE03F, 0xE313, 0xE116, 0xE10F, 0xE104, 0xE103, 0xE101, 0xE102, 0xE13F, 0xE140, 0xE11F, 0xE12F, 0xE031, 0xE30E, 0xE311, 0xE113, 0xE30F, 0xE13B, 0xE42B, 0xE42A, 0xE018, 0xE016, 0xE015, 0xE014, 0xE42C, 0xE42D, 0xE017, 0xE013, 0xE20E, 0xE20C, 0xE20F, 0xE20D, 0xE131, 0xE12B, 0xE130, 0xE12D, 0xE324, 0xE301, 0xE148, 0xE502, 0xE03C, 0xE30A, 0xE042, 0xE040, 0xE041, 0xE12C, 0xE007, 0xE31A, 0xE13E, 0xE31B, 0xE006, 0xE302, 0xE319, 0xE321, 0xE322, 0xE314, 0xE503, 0xE10E, 0xE318, 0xE43C, 0xE11E, 0xE323, 0xE31C, 0xE034, 0xE035, 0xE045, 0xE338, 0xE047, 0xE30C, 0xE044, 0xE30B, 0xE043, 0xE120, 0xE33B, 0xE33F, 0xE341, 0xE34C, 0xE344, 0xE342, 0xE33D, 0xE33E, 0xE340, 0xE34D, 0xE339, 0xE147, 0xE343, 0xE33C, 0xE33A, 0xE43F, 0xE34B, 0xE046, 0xE345, 0xE346, 0xE348, 0xE347, 0xE34A, 0xE349, 0xE036, 0xE157, 0xE038, 0xE153, 0xE155, 0xE14D, 0xE156, 0xE501, 0xE158, 0xE43D, 0xE037, 0xE504, 0xE44A, 0xE146, 0xE154, 0xE505, 0xE506, 0xE122, 0xE508, 0xE509, 0xE03B, 0xE04D, 0xE449, 0xE44B, 0xE51D, 0xE44C, 0xE124, 0xE121, 0xE433, 0xE202, 0xE135, 0xE01C, 0xE01D, 0xE10D, 0xE136, 0xE42E, 0xE01B, 0xE15A, 0xE159, 0xE432, 0xE430, 0xE431, 0xE42F, 0xE01E, 0xE039, 0xE435, 0xE01F, 0xE125, 0xE03A, 0xE14E, 0xE252, 0xE137, 0xE209, 0xE133, 0xE150, 0xE320, 0xE123, 0xE132, 0xE143, 0xE50B, 0xE514, 0xE513, 0xE50C, 0xE50D, 0xE511, 0xE50F, 0xE512, 0xE510, 0xE50E, 0xE21C, 0xE21D, 0xE21E, 0xE21F, 0xE220, 0xE221, 0xE222, 0xE223, 0xE224, 0xE225, 0xE210, 0xE232, 0xE233, 0xE235, 0xE234, 0xE236, 0xE237, 0xE238, 0xE239, 0xE23B, 0xE23A, 0xE23D, 0xE23C, 0xE24D, 0xE212, 0xE24C, 0xE213, 0xE214, 0xE507, 0xE203, 0xE20B, 0xE22A, 0xE22B, 0xE226, 0xE227, 0xE22C, 0xE22D, 0xE215, 0xE216, 0xE217, 0xE218, 0xE228, 0xE151, 0xE138, 0xE139, 0xE13A, 0xE208, 0xE14F, 0xE20A, 0xE434, 0xE309, 0xE315, 0xE30D, 0xE207, 0xE229, 0xE206, 0xE205, 0xE204, 0xE12E, 0xE250, 0xE251, 0xE14A, 0xE149, 0xE23F, 0xE240, 0xE241, 0xE242, 0xE243, 0xE244, 0xE245, 0xE246, 0xE247, 0xE248, 0xE249, 0xE24A, 0xE24B, 0xE23E, 0xE532, 0xE533, 0xE534, 0xE535, 0xE21A, 0xE219, 0xE21B, 0xE02F, 0xE024, 0xE025, 0xE026, 0xE027, 0xE028, 0xE029, 0xE02A, 0xE02B, 0xE02C, 0xE02D, 0xE02E, 0xE332, 0xE333, 0xE24E, 0xE24F, 0xE537];
  for (var i = 0; i < seq.length; i++) {
    var e = seq[i];
    allEmo[String.fromCharCode(e)]={ kind:999, alt:'', src:"/imgpro/emoji/"+e.toString(16).toLowerCase()+".png", wide:false };
  }
	for(var e in emList) {
		allEmo[e]={ kind:0, alt:emList[e].t, src:emList[e].s, wide:emList[e].w };
	}
  for(var e in nEmList) {
    allEmo[e]={ kind:0, alt:nEmList[e].t, src:nEmList[e].s, wide:nEmList[e].w };
  }
  for(var e in bEmList) {
    allEmo[e]={ kind:0, alt:bEmList[e].t, src:bEmList[e].s, wide:bEmList[e].w };
  }
  for(var e in eEmList) {
    allEmo[e]={ kind:0, alt:eEmList[e].t, src:eEmList[e].s, wide:eEmList[e].w };
  }
  for(var e in fEmList) {
    allEmo[e]={ kind:0, alt:fEmList[e].t, src:fEmList[e].s, wide:fEmList[e].w };
  }
  for(var e in sfEmList) {
    allEmo[e]={ kind:0, alt:sfEmList[e].t, src:sfEmList[e].s, wide:sfEmList[e].w };
  }
  for(var e in aEmList) {
    allEmo[e]={ kind:0, alt:aEmList[e].t, src:aEmList[e].s, wide:aEmList[e].w };
  }
  for(var e in odEmList) {
    allEmo[e]={ kind:0, alt:odEmList[e].t, src:odEmList[e].s, wide:odEmList[e].w };
  }

	// 阿狸表情，共51
	var alEmo = ["", "啊啊啊", "安慰", "抱抱", "暴怒", "不要啊", "嘲弄", "吃饭啦", "出走", "大汗", "感动", "好囧", "好冷", "好温暖", "喝茶", "开心", "抠鼻孔", "狂汗", "狂笑", "困了晚安", "你好强", "赖皮", "捏脸", "怒", "爬过", "飘过", "潜水啦", "闪人", "送花给你", "送你礼物", "委屈哭", "我不说话", "喜欢你", "吓唬你", "笑喷了", "旋转", "疑问", "隐身", "郁闷", "抓狂", "转圈哭", "装可爱", "嘘嘘", "晚安", "耍帅", "你伤害了我", "贱扭扭", "寒", "顶顶顶", "大惊", "不耐烦", "不公平"];
	// 囧囧熊表情，共20
	var jjEmo = ["", "被雷到", "打酱油", "得意的笑", "顶", "灌水", "激光", "泪奔", "楼上的", "楼下的", "楼主", "如题", "撒泼", "沙发", "生气", "胜利", "受惊", "刷屏", "吐", "捂嘴偷笑", "阴险"];

	for (var i = 1; i < alEmo.length; i++) {
		allEmo["[al"+(i<10?"0"+i:i)+"]"] = { kind:1, types:2, size:2, alt:alEmo[i], src:"/imgpro/emotions/ali/"+i+".gif"};
	}
	for (var i = 1; i < jjEmo.length; i++) {
		allEmo["[jj"+(i<10?"0"+i:i)+"]"] = { kind:2, types:2, size:2, alt:jjEmo[i], src:"/imgpro/emotions/jiongjiong/"+i+".gif"};
	}

  return allEmo;
}

var em=addExtraEmotions();
var ems=JSON.stringify(em);

console.info(ems);
