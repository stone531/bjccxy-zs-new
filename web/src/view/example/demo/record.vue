<template>
  <div class="app-container">
    <el-card>
      <!-- 表单 -->
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题" required>
          <el-input v-model="form.title" placeholder="请输入标题"></el-input>
        </el-form-item>
        <el-form-item label="内容">
          <el-input 
            v-model="form.content" 
            type="textarea" 
            placeholder="请输入内容"
            rows="4"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleCreate">提交</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table 
        v-loading="loading"
        :data="tableData" 
        border 
        style="width: 100%"
        element-loading-text="数据加载中..."
        element-loading-spinner="el-icon-loading"
      >
        <el-table-column prop="ID" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="content" label="内容" />
        <el-table-column prop="CreatedAt" label="创建时间" width="180">
          <template #default="{row}">
            {{ formatTime(row.CreatedAt) }}
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 空数据提示 -->
      <el-empty v-if="!loading && tableData.length === 0" description="暂无数据" />
    </el-card>
  </div>
</template>

<script>
import { createDemoRecord, getDemoRecordList } from '@/api/record'

export default {
  data() {
    return {
      form: {
        title: '',
        content: ''
      },
      tableData: [],
      loading: false
    }
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    // 格式化时间
    formatTime(time) {
      if (!time) return ''
      
      // 处理后端返回的时间格式 (ISO 8601 with timezone)
      try {
        // 移除时区信息以便正确解析
        const normalizedTime = time.replace(/T/, ' ').replace(/\..+/, '')
        return this.$parseTime(normalizedTime, '{y}-{m}-{d} {h}:{i}:{s}')
      } catch (e) {
        console.error('时间格式化错误:', e)
        return time
      }
    },
    
    // 获取数据
    async fetchData() {
      this.loading = true
      try {
        const res = await getDemoRecordList()
        
        // 确保响应格式正确
        if (res.code === 0 && Array.isArray(res.data)) {
          this.tableData = res.data
        } else {
          console.warn('非预期的响应格式:', res)
          this.$message.warning('获取数据失败，请检查响应格式')
        }
      } catch (error) {
        console.error('获取数据失败:', error)
        this.$message.error('数据加载失败: ' + (error.message || error))
      } finally {
        this.loading = false
      }
    },
    
    // 创建记录
    async handleCreate() {
      if (!this.form.title) {
        this.$message.error('标题不能为空')
        return
      }
      
      try {
        this.loading = true
        await createDemoRecord(this.form)
        this.$message.success('创建成功')
        this.form = { title: '', content: '' }
        this.fetchData() // 刷新数据
      } catch (error) {
        console.error('创建失败:', error)
        this.$message.error('创建失败: ' + (error.message || error))
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
.el-form {
  margin-bottom: 20px;
}
.el-table {
  margin-top: 20px;
}
</style>