<template>
  <div class="external-query">
    <el-card class="box-card">
      <h2>外部查询入口</h2>
      <el-form :model="form">
        <el-form-item label="用户名">
          <el-input v-model="form.username" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleQuery">查询</el-button>
        </el-form-item>
      </el-form>
      <div v-if="result">
        <h3>查询结果：</h3>
        <pre>{{ result }}</pre>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { externalQuery } from '@/api/externalQuery'

const form = ref({
  username: '',
  password: '',
})
const result = ref(null)

const handleQuery = async () => {
  const res = await externalQuery(form.value)
  result.value = res.data
}
</script>
