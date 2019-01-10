## 运行环境

#### Docker

```bash
# 启动 nginx / mysql / phpmyadmin
find . -name "._*" -type f -delete && docker-compose up -d nginx mysql phpmyadmin

# 连接到对应容器
docker-compose exec {container-name} bash

# 查看对应容器日志
docker-compose logs {container-name}

# 查看启动中的容器
docker-compose ps

# 停止所有容器
docker-compose stop

# 停止并删除所有容器
docker-compose down

# 移除不再运行的镜像
docker system prune -a

# 重新建立镜像
docker-compose build --no-cache {container-name}

# Docker 的 MySql操作
docker-compose exec mysql bash

docker-compose exec mysql mysql -u default -psecret

```

#### Host

```bash
# vi /etc/hosts

127.0.0.1    dev.m.51.ca
127.0.0.1    dev.news-app.api.51.ca
127.0.0.1    dev.phpmyadmin.ca
```

#### Database

```bash
# 应用数据库资料
cp database .data

# 访问 dev.phpmyadmin.ca
username = default
password = secret
```

## m.51.ca 开发
#### 本地开发

```bash
npm start
```

在localhost测试的版本，config中的api可设置测试和正式的版本
```bash
测试的api： http://news-app.apidev.51.ca
正式的api： http://news-app.api.51.ca
```

测试版的api在本地调试时不会有跨域问题
正式版的api会出现跨域的问题
解决浏览器跨域的问题，接口需支持多个域名的跨域请求，这个需要中间层开发，因为时间原因现在暂时没有这个功能
现在debug是需要设置chrome，取消跨域限制 （https://stackoverflow.com/questions/3102819/disable-same-origin-policy-in-chrome）
如果是safari可在dev模式下取消跨域限制

如果没有错误，这里会出现很多warning，比如说使用 == 而不是使用 ===。（可忽略）

#### 发布正式版

```bash
npm run-script build
```
打包后会把生成的文件都放在build的文件夹中，上传代码通过FTP
    
build文件夹中有文件.htaccess，此文件是apache的配置文件，如果服务器是apache的话，需要这个文件来支持路由


#### 代码结构

* config/

    打包的相关配置，这里有改动的只有webpack.config.dev.js和webpack.config.prod.js这两个文件，添加了对scss，npm包中css的引入，和static文件拷贝到build目录下的动作

* public/

    包含static的目录，用于index.html中的引用，包含图片和部分css
* scripts/
    
    打包的程序，无修改
* src/

    程序的源代码，文件结构根据redux项目中的real-world样例进行开发

    * actions/

        * alertAction.js
            
            这是与警告提示相关，警告的开发比较复杂，在这里描述一下：警告的文字通过redux进行传输，但是警告确认后的事件通过array(push, pop)的方式来模拟stack，这是考虑到弹出多个警告提示的情况如何处理。
        * commentAction.js

            这里包含评论相关
        * commonAction.js

            收藏和历史记录保存相关
        * newsAction.js

            新闻列表首次调取数据，滑动加载数据，新闻首页轮转图数据，第二页中今日精选数据，新闻详情数据，新闻评论数据，获取新闻历史记录的数据（本地记录id，在显示时把全部id以参数形式传到服务器上来获取列表）
        * rentalAction.js

            租房板块的数据
        * userAction.js

            登陆退出事件，字体切换，简繁体切换时间
        * yellowAction.js

            黄页板块的事件
    * reducers/

        * alert.js

            警告的显示和隐藏
        * common.js

            收藏和历史的保存：这里其实都是把数据存在localstorage中，没有真正意义上的把数据同步到服务器上。使用了queue的方法，把最大保存的个数控制在10个，在已存在10个的情况下，继续增加会把最早的删除。
        * news.js

            新闻数据的操作，新闻收藏和历史记录：这里有些reducer是嵌套在其他reducer中，singleNewsReducer，singleCommentReducer，通过嵌套的方法，把数据归类到自己id底下。所以在开发功能时，这些事件要在父级reducer进行说明。

        * rental.js

            租房数据操作，租房收藏和历史记录，租房地图上的操作，地图
            
        * route.js

            路由的处理和跳转在这里进行（页面ga的page view在这里完成）
        * user.js

            用户登陆退出注册的操作，还有字体转换，简繁转换操作
        * yellow.js

            黄页的数据处理
        
    * constants/
        这里把字符串保存在变量中，方便reducer和action使用，确保两边使用同样的名字


    * components/
        component和container区分https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0
        简单来说，container是处理逻辑，component来处理样式

        项目中有部分container也出现了样式的添加
        * App/

            整个App的layout，sidebar和alert在这里引入
        * Banner/

            这里有banner和indexbanner，banner是fixed的，indexbanner是新闻列表页的banner，不会fixed
        * BoundNotification/

            租房中当从地图转回列表时会弹出当前是已地图为搜索的列表
        * Button/

            主要是租房筛选所用到的按钮
        * CategoryBox/

            黄页首页分类列表的区块，这里有个svg目录用于保存分类的不同图片
        * CommentBox/

            之前详情底部的评论控件，现在没有用到
        * CommentInput/

            评论页面的评论输入框，这里有个autofocus的动作，因为详情页有三个进入评论页，其中只有内容下面的入口有自动focus的需求，所以会在跳转是吧focus传到浏览器state中具体可看：NewsDetailContainer.js:226
        * CommentPage/

            评论页面的layout （如果把container和component分出来后多余的component，需要有更好的设计来解决这种没有意义component的问题）
        
        * DetailFooter/

            租房和黄页的底部联系方式的
        * Digestbox/

            今日精要在列表的模块
        * EmptyBox/

            无数据时的组件，通过传children来显示，renderContent, renderEmphasis是为了黄页板块搜索时显示简繁所开发的功能（现在很多react相关的教程提倡renderProps，来解决样式的不同和功能上的统一，是一个很好的方法：https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce）

        * Favorite/FavoritePage.js

            收藏页面的layout
        * FlexTabs 
            
            新闻列表页顶部的切换功能，这里宽度用到了vw，动画用到了transform，在部分旧手机上支持不好，最好能重新开发一下
        * Form

            这里包含了登陆注册页面的控件
        * History

            历史记录页面的layout
        * ImageSlider

            首页轮转图的控件，这里用到了jquery，和slick这个控件。任何前端插件其实都是可以在react中使用，但是要了解插件的机制，在componentDidMount时启用，在componentWillUnmount来删除任何listener来解决占用内存的问题。（很多插件都提供destroy的api）
        * LoadingBar

            黄页原来有个顶部的加载，来显示加载的功能
        * News/

            * NewsCommentPage

                评论页面的layout
            * NewsDetail

                新闻顶部标题框，和底部相关新闻列表
            * NewsDetailPage

                新闻详情页的layout
            * NewsDigestPage

                新闻精要的layout
            * NewsFontChanger

                新闻文字大小的转化的控件
            * NewsItem
                新闻单条的高度和字体大小通过设计图的大小×屏幕的宽高比计算出来的，因为字体在不同浏览器和场景下会有大小上的偏差，造成折行，而高度还是按单行计算，造成部分内容被隐藏，这在无图版中比较常见，这个问题比较难解决。

                * AdsItem.js

                    简单推广单条
                * ImageOnlyItem.js

                    大图广告单条
                * ManyImageItem.js

                    三张图的新闻
                * PlainItem.js

                    这是当用户选择文字版后，新闻的显示单挑
                * ReviewItem.js

                    新闻评论单条
                * TextImageItem.js

                    正常新闻单条
                * TextOnlyItem.js

                    只有文字单条
            * NewsList

                列表的功能，无限加载功能，在这里计算不同新闻的高度，提供给父级，来解决之前出现的100条之后页面卡顿的问题，用了https://github.com/seatgeek/react-infinite，具体原理可阅读https://developers.google.com/web/updates/2016/07/infinite-scroller

                可以往这个方向重新开发 https://zhuanlan.zhihu.com/p/32075662
                
            * NewsListPage

                新闻列表页的layout
            * NewsStateList

                新闻收藏和历史记录的列表
            * ReviewItem

                新闻评论的单条 （弃用）
            * index.js

                新闻总的layout，用于news/这个route下的显示
        * NotFound

            404页面
        * Rental

            * filter

                * LocationSelector.js

                    租房筛选顶部的地区选择
                * MoveDateSelector.js

                    搬入日期，react-date的控件
                * PublishSelector.js

                    发布时间的控件
                * RowSelector.js

                    多选的控件
            * RentalHistoryList

                房源浏览历史记录
            * RentalItem

                房源单条，这个组件用在列表和地图点点开后的列表页中
            * RentalMapList

                地图点点开后的列表
            * RentalMapPoint

                地图上的店，使用overlayview来显示，如果使用点，在自定义图标的情况会出现严重的偏移
            * RentalSearchBox

                租房的搜索框，使用了geosuggest，因为google的api是异步调用进来的，所以这里用到了withScriptJs这个组件
            * index.js

                租房整个的layout
            * RentalDetIlPage.js

                租房详情的结构
            * RentalList.js

                租房列表，与新闻一样使用了无限加载的控件
            * RentalListPage.js

                租房列表的layout
            * RentalListMap.js

                租房列表的layout
        * SimpleAlert

            退出，或者错误的弹窗
        * TagGroup
        * TermPage

            注册页面可跳转到合同页面
        * User

            登陆和注册页面的layout
        * Yellow
            * YellowCategoryPage

                黄页分类页的layout
            * YellowDetail

                * DetailBox.js

                    详情页文字详情的控件，负责展开详情的功能
                * ImageBox.js

                    黄页详情中有图片的滑动控件和点开大图的显示
                * TagBox.js

                    黄页详情和租房详情有很多内容通过tag的方式进行显示，通过这个控件来循环显示tag
                * TitleInfoBox.js

                    黄页租房详情标题的显示
            * YellowItem

                黄页的单条
            * YellowList

                黄页列表（黄页列表没有使用无限加载，而是直接调取200条黄页数据）
            * YellowListPage

                黄页列表的layout
            * YellowSearchPage

                黄页搜索页面的layout
            * YellowStaticList

                黄页收藏和浏览历史的列表
            * index.js
        * AdContainer

            显示广告的控件，统一在底部显示推广文字，通过控件的方式来统一广告样式。
    * containers/
        
        这个目录下是每个页面的逻辑，使用redux和immutablejs来保存数据，使用shouldComponentUpdate和pureComponent 来提高效能。

        * Alert

            警告逻辑，这里从window.__function__pool取最后一个函数来当作确认的事件，在创建警告时，每次都要传一个函数来处理成功后的动作，可参考containers/sidebar/index.js:275
        * Comment

            评论
        * Favorite
            新闻黄页和租房的收藏功能

        * FilterBox

            租房也中顶部的搜索和筛选共
        * History

            新闻黄页和租房的历史记录功能
        * News

            * LeadNewsContainer.js / LifeNewsContainer.js / LocalNewsContainer.js / PopularNewsContainer.js

                新闻列表页：新闻的加载分成初次加载和继续加载的动作，初次加载会判断列表新闻的个数，之后会根据offset继续加载数据

                现在新闻列表的bug，其实是新闻更新时，有新闻添加，全部新闻会向后推，所以导致第二页会和第一页有重复的问题。这个问题要在接口上支持时间点取新闻数据。

                这里我们跳转到详情页会带一个 { fromApp: true } 的state，我们在详情页判断是否有fromApp，让顶部的后退在true的情况下后退，false或者undefined的情况下跳转到列表页。

            * NewsDetailContainer.js

                新闻详情页面
                
                * 广告。程序的广告系统在前端使用js加载的，后端是revive的广告系统，而且会在页面完成全部加载工作，因为项目的页面是在异步加载进来的，所以广告没办法用正常的方法加载。发现广告系统js提供了一个异步加载的api，现在暂时能用，具体用法请参考： NewsDetailContainer.js:96

                * 这里实现componentDidUpdate的原因是点击底部相关新闻其实不是重新打开页面，而是在当前页面更新数据

                * 延迟加载：中间层会用正则表达式替换图片的class，在详情加载和显示后对演示加载进行初始化的动作，参考NewsDetailContainer.js:69
            * Rental

                * rental/

                    租房地图上的图标
                * RentalFilterContainer.js

                    租房筛选打开后的逻辑控件，这里在第一次mount时会加载配置文件，只用到地区的数据，数据里包含了坐标和zoom level，当点击时候, 地图的坐标和zoom level也会更新

                    入住时间只有在日期选择后才能调整前后选项
                * RentalMapContainer.js

                    地图的数据从服务器返回，聚合的工作会在服务器上完成，所以本地只需要显示和添加点击放大到特定的区域即可
        * Sidebar

            左侧弹出的菜单。这里用了react-toolbox的drawer插件，因为用来了css variable，对旧版手机支持不是很好，可选择重新开发。
        * User

            登陆和注册
        * Yellow

            黄页相关，很多控件都在租房的详情内复用

    * locales

        简繁翻译的功能
        * index.js

            这里使用mobx来更新文字简繁体，因为不能使用i18n的api，我们通过更改state的方式改变文字简繁。参考：https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076

    * utils

        * calcLength

            判断字符串在页面的长度
        * convertToUrlQuery

            租房的筛选转换成url字符串
        * isMobile

            判断浏览器
        * variable

            页面的宽高比

    * localStorage.js

        同步state到localstorage，用于保存用户设置，收藏和浏览历史
* index.html

    head中添加了rollbar的代码，用于错误监控，每小时采集6个事件，来控制每月5000个事件的免费额度
    文件中有web app的配置文件
    * theme-color   用于chrome头部展示的颜色
    * app-mobile-web-app-title  safari添加到桌面时显示的名字
    * app-itunes-app safari支持在首次打开时展示app store中的app
    * app-touch-icon    添加到桌面时显示的图标
    * manifest  chrome添加到桌面的相关配置
    * apple-mobile-web-app-status-bar-style safari头部颜色的控制

    文件底部有个_51_a_after_loaded = null 和 wuyoujs.php的加载，这些是广告系统所需要的文件，