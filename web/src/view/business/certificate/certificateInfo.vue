<template>
  <div class="student-detail-container">
    <div class="title-box">
      <p class="main-title">为方便用人单位核实毕业证，我院推出电子注册毕业证查询系统。</p>
      <p class="sub-title">请认真填写下面的各项内容，查询系统将按照您填写的资料进行数据库搜索。</p>
    </div>

    <el-row :gutter="20" class="info-box">
      <el-col :span="18">
        <el-descriptions column="2" border>
          <el-descriptions-item label="姓名">{{ student.name }}</el-descriptions-item>
          <el-descriptions-item label="性别">{{ student.sex }}</el-descriptions-item>

          <el-descriptions-item label="出生年月">{{ student.age }}</el-descriptions-item>
          <el-descriptions-item label="民族">{{ student.mingzhu }}</el-descriptions-item>

          <el-descriptions-item label="政治面貌">{{ student.zzmm }}</el-descriptions-item>
          <el-descriptions-item label="籍贯">{{ student.nativeplace }}</el-descriptions-item>

          <el-descriptions-item label="层次">{{ student.chengchi }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">{{ student.certificatenumber2 }}</el-descriptions-item>

          <el-descriptions-item label="专业">{{ student.zhuanye }}</el-descriptions-item>
          <el-descriptions-item label="毕业证号">{{ student.graduschool }}</el-descriptions-item>

          <el-descriptions-item label="毕业院校">{{ student.graduschool2 }}</el-descriptions-item>
          <el-descriptions-item label="毕业时间">{{ student.bysj }}</el-descriptions-item>

          <el-descriptions-item label="自我鉴定" :span="2">
            {{ student.zwjd }}
          </el-descriptions-item>

          <el-descriptions-item label="备注" :span="2">
            {{ student.demo }}
          </el-descriptions-item>
        </el-descriptions>
      </el-col>

      <el-col :span="6" class="avatar-box">
        <el-image
          :src="student.pic"
          fit="cover"
          style="width: 120px; height: 160px; border: 1px solid #ccc"
        />
      </el-col>
    </el-row>
  </div>
</template>


<script setup>

import {
    getZhengshuList
  } from '@/api/user'

import { reactive } from 'vue'

import { useRoute } from 'vue-router'
import { onMounted, ref } from 'vue'

const route = useRoute()
const tableData = ref([])

const searchInfo = ref({
    name: '',//姓名
    graduschool: '',//证书号
    certificatenumber2: '',//身份证号
    id: ''//主键ID
  })
// 查询
  const getTableData = async () => {
    const table = await getZhengshuList({
      page: 1,
      pageSize: 1,
      ...searchInfo.value
    })
    if (table.code === 0) {
      tableData.value = table.data.list
    }
  }

  onMounted(() => {
    getTableData()
  })

  //const initPage = async () => {
  //  getTableData()
  //}

  //initPage()

 defineOptions({
    name: 'certificateInfo'
  })

// 示例数据，后续可以用后端接口填充
const student = reactive({
  name: '',
  sex: 1,//性别
  age: '',//出生年月日
  mingzhu: '汉族',
  pic: '', // 替换成你实际的图片地址
  nativeplace: '',//籍贯
  zzmm: '',//政治面貌
  chengchi: '',//成次，本科，专科
  certificatenumber2: '',//身份证
  zhuanye: '',//专业
  graduschool:'',//毕业证书号
  graduschool2:'',//毕业院校
  bysj: '',//毕业时间
  zwjd: '',//自我鉴定
  demo: '',//备注
 
})

</script>

<style scoped>
.student-detail-container {
  padding: 20px;
  background: #fff;
  border: 1px solid #f1f1f1;
}

.title-box {
  text-align: center;
  margin-bottom: 30px;
}

.title-box .main-title {
  font-size: 18px;
  color: red;
  margin: 5px 0;
}

.title-box .sub-title {
  color: #f56c6c;
  font-weight: bold;
}

.info-box {
  margin-top: 20px;
}

.avatar-box {
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.text-danger {
  color: red;
}
.font14b {
  font-size: 14px;
  font-weight: bold;
}
</style>
