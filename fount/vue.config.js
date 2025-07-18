module.exports = {
  productionSourceMap: false, //打包不生成map文件
  configureWebpack: {
    devtool: "none", //在控制台source中隐藏webpack代码
  },
  lintOnSave: true,
  css: {
    loaderOptions: {
      sass: {
        sassOptions: {
          // 输出风格改为 expanded (避免伪元素中的字符被转义）
          outputStyle: "expanded",
        },
      },
      postcss: {
        plugins: [
          //postcss-pxtorem 版本必须为5.1.1 否则会报错
          require("postcss-pxtorem")({
            rootValue: 16, // 指定转换倍率，我现在设置这个表示1rem=16px;
            minPixelValue: 1, // 需要转换的最小值，一般1px像素不转换，以上才转换
            selectorBlackList: [".el"], // 匹配不被转换为rem的选择器
            mediaQuery: false, // 允许在媒体查询中转换px
          }),
        ],
      },
    },
  },
  devServer: {
    // static: {
    //   publicPath: "./public",
    // },
  },
  publicPath: "/vis",
  outputDir: "vis",
};
