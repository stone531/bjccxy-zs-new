<!-- src/layout/home.vue -->
<template>
  <el-container style="height: 100vh">
    <el-aside width="200px" class="aside">
      <div class="logo">学生系统</div>
      <el-menu :router="true" :default-active="$route.path">
        <el-menu-item index="/student/info">
          <el-icon><User /></el-icon>我的信息
        </el-menu-item>
        <el-menu-item index="/student/order">
          <el-icon><List /></el-icon>我的订单
        </el-menu-item>
        <el-menu-item index="/student/certificate">
          <el-icon><Document /></el-icon>毕业证书申请
        </el-menu-item>
        <el-menu-item index="/student/quit">
          <el-icon><Document /></el-icon>退出登录
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { User, List, Document } from '@element-plus/icons-vue'
</script>

<style scoped>
.logo {
  text-align: center;
  font-size: 20px;
  padding: 20px 0;
  font-weight: bold;
}
.aside {
  background-color: #f8f8f8;
  border-right: 1px solid #eee;
}
</style>
