<template>
  <div>
    <warning-bar
  :title="`温馨提示：为了你的信息通过审核，请仔细填写下表。`"
  style="color: red; white-space: pre-line"
/>
    <div class="gva-adduser-box">
      <el-form ref="userForm" :rules="rules" :model="userInfo" label-width="80px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userInfo.gender">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="身份证号" prop="id_card_number">
          <el-input
            v-model="userInfo.id_card_number"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="证书名称" prop="certificate_name">
          <el-input v-model="userInfo.certificate_name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="培训项目" prop="training_program">
          <el-input v-model="userInfo.training_program" style="width: 200px" />
        </el-form-item>

        <el-form-item label="证书编号" prop="certificate_id">
          <el-input v-model="userInfo.certificate_id" style="width: 200px" />
        </el-form-item>

        <el-form-item label="发证日期" prop="issue_date">
          <el-date-picker
            v-model="userInfo.issue_date"
            type="month"
            placeholder="选择毕业年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>

        <el-form-item label="成绩评定" prop="grade">
          <el-input v-model="userInfo.grade" style="width: 200px" />
        </el-form-item>

        <el-form-item label="备注" prop="extra_field1">
          <el-input v-model="userInfo.extra_field1" style="width: 300px" />
        </el-form-item>

        <el-form-item>
          <el-row justify="center">
            <el-col>
              <el-button @click="addUserFunc" type="primary" round>证书录入</el-button>
              <el-button @click="resetUserFunc" type="primary" round>重新填写</el-button>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useAppStore } from '@/pinia'
import WarningBar from '@/components/warningBar/warningBar.vue'
import { insertTrainStu } from '@/api/user.js'
import { useUserStore } from '@/pinia/modules/user'

defineOptions({ name: 'trainingAdd' })

const appStore = useAppStore()
const userStore = useUserStore()
const userInfo = ref({
  name: '',
  gender: 1,
  id_card_number: '',
  certificate_name: '',
  certificate_id: '',
  issue_date: '',
  training_program: '',
  grade: '',
  extra_field1: '',
  editer:userStore.userInfo.userName
})

const rules = ref({
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  certificate_name: [{ required: true, message: '请输入培训名称', trigger: 'change' }],
  certificate_id: [{ required: true, message: '请输入培训证书号', trigger: 'change' }],
  id_card_number: [
    { required: true, message: '请输入身份证号', trigger: 'blur' },
    {
      pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])\d{3}[\dXx]$/,
      message: '请输入合法的18位身份证号码',
      trigger: 'blur'
    }
  ],
  issue_date: [{ required: true, message: '请输入发证日期', trigger: 'change' }],
  grade: [{ required: true, message: '请输入成绩', trigger: 'change' }],
  training_program: [{ required: true, message: '请输培训项目', trigger: 'blur' }],
  extra_field1: [{ trigger: 'change' }]
})

const addUserFunc = async () => {
  try {
    const res = await insertTrainStu(userInfo.value)
    if (res.code === 0) {
      ElMessage.success('创建成功')
      resetUserFunc()
    }
  } catch (error) {
    ElMessage.error('提交失败，请重试')
  }
}

const resetUserFunc = () => {
  Object.assign(userInfo.value, {
    name: '',
    gender: 1,
    id_card_number: '',
    certificate_name: '',
    certificate_id: '',
    issue_date: '',
    training_program: '',
    grade: '',
    extra_field1: ''
  })
}

</script>

<style lang="scss" scoped>
.header-img-box {
  @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
}

.warning-bar-text {
  color: red;
  white-space: pre-line;
}
</style>
