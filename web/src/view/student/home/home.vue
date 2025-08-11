<!-- src/layout/home.vue -->
<template>
  <el-container style="height: 100vh">
    <el-aside width="200px" class="aside">
      <div class="logo">学生系统</div>
      <el-menu :router="true" :default-active="$route.path">
        <el-menu-item index="/student/info">
          <el-icon><User /></el-icon>我的信息
        </el-menu-item>
        <el-menu-item index="/student/certificate">
          <el-icon><Document /></el-icon>证书申请
        </el-menu-item>
        <el-menu-item index="/student/order">
          <el-icon><List /></el-icon>我的订单
        </el-menu-item>    
        <el-menu-item index="/student/quit">
          <el-icon><List /></el-icon>test
        </el-menu-item>       
        <el-menu-item @click="logout">
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
import { useRouter } from 'vue-router'
import { useStudentStore } from '@/pinia/modules/student'
import { ElMessageBox, ElMessage } from 'element-plus'

const router = useRouter()
const studentStore = useStudentStore()

const logout = () => {
  ElMessageBox.confirm('确定要退出登录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      // 1. 清除 student-token（看你存哪里，这里两个都清一下）
      studentStore.LoginOut()

      // 3. 跳转到学生登录页
      router.push('/student-login')

      ElMessage.success('已退出登录')
    })
    .catch(() => {
      // 用户取消，不做操作
    })
}

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
