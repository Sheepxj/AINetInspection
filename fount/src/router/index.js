import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const originalPush = VueRouter.prototype.push;
// 解决ElementUI导航栏中的vue-router在3.0版本以上重复点菜单报错问题
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch((err) => err);
};

const routes = [
  {
    path: "/login",
    name: "login",
    component: () => import("../views/login.vue"),
  },
  {
    path: "/prompt",
    name: "prompt",
    component: () => import("../views/prompt.vue"),
  },
  {
    path: "/",
    redirect: "/billboards",
    name: "home",
    component: () => import("../views/home.vue"),
    children: [
      {
        path: "billboards",
        name: "billboards",
        component: () => import("../views/billboards/index.vue"),
      },
      {
        path: "task/",
        redirect: "task/target",
        component: () => import("../views/task/index.vue"),
        children: [
          {
            path: "target",
            name: "targetTask",
            component: () => import("../views/task/target/index.vue"),
          },
        ],
      },
      {
        path: "task/target/create",
        name: "targetTaskCreate",
        component: () => import("../views/task/target/create.vue"),
      },
      {
        path: "warning",
        name: "warning",
        component: () => import("../views/warning/index.vue"),
      },
      {
        path: "access",
        name: "access",
        component: () => import("../views/access/index.vue"),
      },
      {
        path: "algorithm",
        name: "algorithm",
        component: () => import("../views/algorithm/index.vue"),
      },
      {
        path: "myself",
        name: "myself",
        component: () => import("../views/myself/index.vue"),
      },
    ],
  },
  {
    path: "/app/index",
    name: "appIndex",
    component: () => import("../views/app/index.vue"),
  },
  {
    path: "/app/event",
    name: "appEvent",
    component: () => import("../views/app/event.vue"),
  },
];

const router = new VueRouter({
  mode: "history",
  base: "/vis/",
  routes,
  // 当路由跳转后滚动条所在的位置
  scrollBehavior(to, from, savedPosition) {
    // return 期望滚动到哪个的位置
    return { x: 0, y: 0 };
  },
});

//路由前置守卫
router.beforeEach((to, from, next) => {
  if (!["/login", "/prompt"].includes(to.path)) {
    //判断进入其他页面是否携带token
    if (localStorage.getItem("Authorization")) {
      next();
    } else {
      router.replace("/login");
    }
  } else {
    next();
  }
});

export default router;
