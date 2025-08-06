<template>
  <div class="gva-container">
    <div class="gva-card">

      <!-- 毕业证书 -->
      <el-card class="cert-card">
        <div class="card-header">
          <span class="title">毕业证书</span>
          <el-button type="primary" icon="plus" @click="addUser">
            增加毕业证书
          </el-button>
        </div>

        <div class="card-body">
          <template v-if="graduationCert">
            <div class="cert-item">
              <div class="cert-info">
                <p>证书名称：{{ graduationCert.name }}</p>
                <p>编号：{{ graduationCert.no }}</p>
                <p>颁发日期：{{ graduationCert.date }}</p>
              </div>
              <el-button size="small" type="primary" plain @click="viewDetails(graduationCert)">
                证书详情
              </el-button>
            </div>
          </template>
          <template v-else>
            <el-empty description="暂无毕业证书"></el-empty>
          </template>
        </div>
      </el-card>

      <!-- 结业证书（多条） -->
      <el-card class="cert-card">
        <div class="card-header">
          <span class="title">结业证书</span>
          <el-button type="primary" icon="plus" @click="addTrainingUser">
            增加结业证书
          </el-button>
        </div>

        <div class="card-body">
          <template v-if="completionCertList.length">
            <el-table
              :data="completionCertList"
              border
              size="small"
              style="width: 100%"
            >
              <el-table-column prop="name" label="证书名称" min-width="160" />
              <el-table-column prop="no" label="编号" min-width="120" />
              <el-table-column prop="date" label="颁发日期" min-width="120" />
              <el-table-column label="操作" width="120">
                <template #default="{ row }">
                  <el-button
                    type="primary"
                    size="small"
                    plain
                    @click="viewDetails(row)"
                  >
                    详情
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </template>
          <template v-else>
            <el-empty description="暂无结业证书"></el-empty>
          </template>
        </div>
      </el-card>

    </div>

      <!-- 增加毕业证书用户信息 -->
    <el-drawer
      v-model="addUserDialog"
      :size="600"
      :show-close="false"
      :close-on-press-escape="false"
      :close-on-click-modal="false"
    >
      <template #header>
        <div class="flex justify-between items-center">
          <span class="text-lg">在线申请毕业证书</span>
          <div>
            <el-button @click="closeAddUserDialog">取 消</el-button>
            <el-button type="primary" @click="enterAddUserDialog"
              >确 定</el-button
            >
          </div>
        </div>
      </template>

      <el-form
        ref="userForm"
        :rules="rules"
        :model="userInfo"
        label-width="80px"
      >

        <el-form-item label="用户名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="sex">
          <el-radio-group v-model="userInfo.sex">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="出生年月" prop="age">
          <el-date-picker
            v-model="userInfo.age"
            type="date"
            placeholder="选择出生年月"
            style="width: 200px"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>

        <el-form-item label="民族" prop="mingzhu">
          <el-select v-model="userInfo.mingzhu" placeholder="请选择民族" style="width: 200px">
            <el-option v-for="item in nations" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>

        <el-form-item label="证件照片" prop="pic" label-width="80px">
          <SelectImage v-model="userInfo.pic" />
        </el-form-item>

        <el-form-item label="籍贯" prop="nativeplace">
          <el-select v-model="userInfo.nativeplace" placeholder="请选择籍贯" style="width: 200px" filterable>
            <el-option v-for="place in nativeplaces" :key="place" :label="place" :value="place" />
          </el-select>
        </el-form-item>

        <el-form-item label="身份证号" prop="certificatenumber2">
          <el-input
            v-model="userInfo.certificatenumber2"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="专业" prop="zhuanye">
          <el-input v-model="userInfo.zhuanye" style="width: 200px" />
        </el-form-item>

        <el-form-item label="毕业时间" prop="bysj">
          <el-date-picker
            v-model="userInfo.bysj"
            type="month"
            placeholder="选择毕业年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>
      </el-form>  

    </el-drawer>

    <!-- 增加培训证书用户信息 -->
    <el-drawer
      v-model="addTrainingUserDialog"
      :size="600"
      :show-close="false"
      :close-on-press-escape="false"
      :close-on-click-modal="false"
    >
      <template #header>
        <div class="flex justify-between items-center">
          <span class="text-lg">在线申请结业证书</span>
          <div>
            <el-button @click="closeAddTrainingUserDialog">取 消</el-button>
            <el-button type="primary" @click="enterAddTrainingUserDialog"
              >确 定</el-button
            >
          </div>
        </div>
      </template>

      <el-form
        ref="trainingUserForm"
        :rules="rules"
        :model="trainingUserInfo"
        label-width="150px"
      >

        <el-form-item label="用户名" prop="name">
          <el-input v-model="trainingUserInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="trainingUserInfo.gender">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="身份证号" prop="id_card_number">
          <el-input
            v-model="trainingUserInfo.id_card_number"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="证书名称" prop="certificate_name">
          <el-input v-model="trainingUserInfo.certificate_name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="证书编号" prop="certificate_id">
          <el-input v-model="trainingUserInfo.certificate_id" style="width: 200px" />
        </el-form-item>

        <el-form-item label="培训项目名称" prop="training_program">
          <el-input v-model="trainingUserInfo.training_program" style="width: 200px" />
        </el-form-item>

        <el-form-item label="结业日期" prop="issue_date">
          <el-date-picker
            v-model="trainingUserInfo.issue_date"
            type="month"
            placeholder="选择毕业年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>
      </el-form>  

    </el-drawer>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
// API 方法（替换成你的接口）
import SelectImage from '@/components/upload/zsCommon.vue'
import { getCertificateList } from '@/api/student'
import { useAppStore } from "@/pinia";

const appStore = useAppStore()

// 数据
const graduationCert = ref(null) // 毕业证书
const completionCertList = ref([]) // 多个结业证书

const userForm = ref(null)

//毕业证书
const closeAddUserDialog = () => {
    userForm.value.resetFields()
    addUserDialog.value = false
  }

const addUserDialog = ref(false)

const dialogFlag = ref('add')

const addUser = () => {
  dialogFlag.value = 'add'
  addUserDialog.value = true
}

//培训证书
const closeAddTrainingUserDialog = () => {
    trainingUserForm.value.resetFields()
    addTrainingUserDialog.value = false
  }

const addTrainingUserDialog = ref(false)

const dialogTrainingFlag = ref('add')

const addTrainingUser = () => {
  dialogTrainingFlag.value = 'add'
  addTrainingUserDialog.value = true
}

// 弹窗相关
  const userInfo = ref({
    name: '',
    age: '',
    sex: '',
    mingzhu: '',
    pic: '',
    nativeplace: '',
    bysj: '',
    zhuanye:'',
    certificatenumber2:''
  })

  const nations = [
  "汉族", "蒙古族", "回族", "藏族", "维吾尔族", "苗族", "彝族", "壮族", "布依族", "朝鲜族",
  "满族", "侗族", "瑶族", "白族", "土家族", "哈尼族", "哈萨克族", "傣族", "黎族", "傈僳族",
  "佤族", "畲族", "高山族", "拉祜族", "水族", "东乡族", "纳西族", "景颇族", "柯尔克孜族", "土族",
  "达斡尔族", "仫佬族", "羌族", "布朗族", "撒拉族", "毛南族", "仡佬族", "锡伯族", "阿昌族", "普米族",
  "塔吉克族", "怒族", "乌孜别克族", "俄罗斯族", "鄂温克族", "德昂族", "保安族", "裕固族", "京族", "塔塔尔族",
  "独龙族", "鄂伦春族", "赫哲族", "门巴族", "珞巴族", "基诺族"
]
const nativeplaces = [
  "北京", "上海", "天津", "重庆", "河北", "山西", "辽宁", "吉林", "黑龙江", "江苏", "浙江", "安徽",
  "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "海南", "四川", "贵州", "云南", "陕西",
  "甘肃", "青海", "台湾", "内蒙古", "广西", "西藏", "宁夏", "新疆", "香港", "澳门"
]

  const rules = ref({
    userName: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 5, message: '最低5位字符', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入用户密码', trigger: 'blur' },
      { min: 6, message: '最低6位字符', trigger: 'blur' }
    ],
    nickName: [{ required: true, message: '请输入用户昵称', trigger: 'blur' }],
    phone: [
      {
        pattern: /^1([38][0-9]|4[014-9]|[59][0-35-9]|6[2567]|7[0-8])\d{8}$/,
        message: '请输入合法手机号',
        trigger: 'blur'
      }
    ],
    email: [
      {
        pattern: /^([0-9A-Za-z\-_.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/g,
        message: '请输入正确的邮箱',
        trigger: 'blur'
      }
    ],
    authorityId: [
      { required: true, message: '请选择用户角色', trigger: 'blur' }
    ]
  })


  //培训证书
  const trainingUserInfo = ref({
    name: '',
    age: '',
    sex: '',
    mingzhu: '',
    pic: '',
    nativeplace: '',
    bysj: '',
    zhuanye:'',
    certificatenumber2:''
  })

  const trainingUserForm = ref(null)

// 模拟接口请求
onMounted(async () => {
  /*graduationCert.value = {
    name: '本科毕业证书',
    no: 'GRA-2023-001',
    date: '2023-07-01'
  }
  completionCertList.value = [
    { name: 'Java Web 开发结业证书', no: 'COM-2024-101', date: '2024-05-10' },
    { name: 'Vue 前端进阶结业证书', no: 'COM-2024-202', date: '2024-06-20' }
  ]*/
 try {
  const res = await getCertificateList()
  if (res.code === 0 && res.data?.certicates) {
    // 毕业证书
    if (res.data.certicates.graduationCert) {
      const grad = res.data.certicates.graduationCert
      graduationCert.value = {
        name: grad.major || '',
        no: grad.certificateNum || '',
        date: grad.date || ''
      }
    }

    // 结业证书（映射字段）
    completionCertList.value = (res.data.certicates.completionCert || []).map(item => ({
      name: item.name || '',
      no: item.certificateNum || '',
      date: item.date || ''
    }))
  } else {
    ElMessage.error(res.msg || '获取学生信息失败')
  }
 } catch (err) {
  console.error('请求证书信息列表失败', err)
  ElMessage.error('请求证书信息列表失败')
}
})

const enterAddUserDialog = async () => {
    //userInfo.value.authorityId = userInfo.value.authorityIds[0]
    userForm.value.validate(async (valid) => {
      if (valid) {
        const req = {
          ...userInfo.value
        }
        if (dialogFlag.value === 'edit') {
          const res = await setZhengshuInfo(req)
          if (res.code === 0) {
            ElMessage({ type: 'success', message: '编辑成功' })
            await getTableData()
            closeAddUserDialog()
          }
        }
      }
    })
  }

  const enterAddTrainingUserDialog = async () => {
    trainingUserForm.value.validate(async (valid) => {
      if (valid) {
        const req = {
          ...trainingUserInfo.value
        }
        if (dialogTrainingFlag.value === 'edit') {
          const res = await setZhengshuInfo(req)
          if (res.code === 0) {
            ElMessage({ type: 'success', message: '编辑成功' })
            await getTableData()
            closeAddTrainingUserDialog()
          }
        }
      }
    })
  }

// 增加证书
function addCertificate(type) {
  ElMessage.success(`跳转到新增 ${type === 'graduation' ? '毕业证书' : '结业证书'} 页面`)
  // router.push(...)
}

// 查看详情
function viewDetails(cert) {
  ElMessage.success(`查看 ${cert.name} 详情`)
  // router.push(...)
}
</script>

<style scoped>
.gva-card {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}
.cert-card {
  flex: 1;
  min-width: 450px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}
.cert-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.cert-info p {
  margin: 0;
  font-size: 14px;
}
</style>
