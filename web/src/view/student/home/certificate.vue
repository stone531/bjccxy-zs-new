<template>
  <div class="gva-container">
    <div class="gva-card">

      <!-- 毕业证书 -->
      <el-card class="cert-card">
        <div class="card-header">
          <span class="title">毕业证书</span>

          <!-- 当没有证书时才显示“增加毕业证书”按钮 -->
          <el-button
            v-if="!graduationCert"
            type="primary"
            icon="plus"
            @click="addUser"
          >
            增加毕业证书
          </el-button>
        </div>

        <div class="card-body">
          <template v-if="graduationCert">
            <div class="cert-item">
              <div class="cert-info">
                <p>证书名称：{{ graduationCert.name }}</p>
                <p>证书编号：{{ graduationCert.no }}</p>
                <p>颁发日期：{{ graduationCert.date }}</p>                
                <p>
                  是否发布：
                  <el-tag type="success" v-if="graduationCert.publish === 'yes'">已发布</el-tag>
                  <el-tag type="warning" v-else>未发布</el-tag>
                </p>
              </div>
              <el-button
                size="small"
                type="primary"
                plain
                @click="viewDetails('certificate', graduationCert.id)"
              >
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
              <el-table-column prop="no" label="证书编号" min-width="160" />
              <el-table-column prop="date" label="颁发日期" min-width="80" />
              
              <el-table-column label="是否发布" min-width="80">
                <template #default="{ row }">
                  <el-tag
                    :type="row.publish === 'yes' ? 'success' : 'warning'"
                  >
                    {{ row.publish === 'yes' ? '已发布' : '未发布' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="60">
                <template #default="{ row }">
                  <el-button
                    type="primary"
                    size="small"
                    plain
                    @click="viewDetails('train',row.id)"
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
        :rules="certRules"
        :model="userInfo"
        label-width="80px"
      >
      <warning-bar
      :title="`温馨提示：为了你的信息通过审核，请仔细填写下表。\n1、上传照片要求：照片必须是近期正面免冠彩色头像，不小于295像素(宽)x413像素(高)，头部占尺寸的2/3，白色背景无边框，图像清晰、层次丰富、神态自然、无明显畸变。\n2、系统将对所填姓名、证件类型、证件号码、个人照片进行实名认证，请填写个人真实信息，上传个人真实照片。\n3、上传的照片用于考生报名及合格人员证书制作。`"
       style="color: red;"
      class="multiline-warning"
    />
        <el-form-item label="用户名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" disabled />
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
            disabled
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
        :rules="trainingRules"
        :model="trainingUserInfo"
        label-width="150px"
      >
        <warning-bar
      :title="`温馨提示：为了你的信息通过审核，请仔细填写下表。\n1、上传照片要求：照片必须是近期正面免冠彩色头像，不小于295像素(宽)x413像素(高)，头部占尺寸的2/3，白色背景无边框，图像清晰、层次丰富、神态自然、无明显畸变。\n2、系统将对所填姓名、证件类型、证件号码、个人照片进行实名认证，请填写个人真实信息，上传个人真实照片。\n3、上传的照片用于考生报名及合格人员证书制作。`"
        style="color: red;"
        class="multiline-warning"
      />
        <el-form-item label="用户名" prop="name">
          <el-input v-model="trainingUserInfo.name" style="width: 200px" disabled />
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
            disabled
          />
        </el-form-item>

        <el-form-item label="证书名称" prop="certificate_name">
          <el-input v-model="trainingUserInfo.certificate_name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="培训项目名称" prop="training_program">
          <el-input v-model="trainingUserInfo.training_program" style="width: 200px" />
        </el-form-item>

        <el-form-item label="成绩评定" prop="grade">
          <el-input v-model="trainingUserInfo.grade" style="width: 200px" />
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
import SelectImage from '@/components/upload/zsCommon-stu.vue'
import { getCertificateList } from '@/api/student'
//import { insertZhengshu ,insertTrainStu} from '@/api/user.js'
import { useStudentStore } from '@/pinia/modules/student'
import { getStudentInfo, insertZhengshu ,insertTrainStu } from '@/api/student'
import { useRouter } from 'vue-router'
import WarningBar from '@/components/warningBar/warningBar.vue'
//import { sleep } from '@/utils/sleep';

const studentStore = useStudentStore()
const router = useRouter()

const graduationCert = ref(null) 
const completionCertList = ref([]) 

const userForm = ref(null)
const addUserDialog = ref(false)
const trainingUserForm = ref(null)
const addTrainingUserDialog = ref(false)

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

const certRules = ref({
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  sex: [{ required: true, message: '请选择性别', trigger: 'change' }],
  age: [{ required: true, message: '请选择出生年月', trigger: 'change' }],
  mingzhu: [{ required: true, message: '请选择民族', trigger: 'change' }],
  certificatenumber2: [
    { required: true, message: '请输入身份证号', trigger: 'blur' },
    {
      pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])\d{3}[\dXx]$/,
      message: '请输入合法的18位身份证号码',
      trigger: 'blur'
    }
  ],
  pic: [{ required: true, message: '请上传证件照', trigger: 'change' }],
  nativeplace: [{ required: true, message: '请选择籍贯', trigger: 'change' }],
  zhuanye: [{ required: true, message: '请输入专业', trigger: 'blur' }],
  bysj: [{ required: true, message: '请选择毕业时间', trigger: 'change' }]
})

const trainingRules = ref({
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  id_card_number: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
  certificate_name: [{ required: true, message: '请输入培训名称', trigger: 'blur' }],
  training_program: [{ required: true, message: '请输入培训项目', trigger: 'blur' }],
  issue_date: [{ required: true, message: '请选择结业日期', trigger: 'change' }],
  grade: [{ required: true, message: '请输入成绩', trigger: 'change' }],
})

const userInfo = ref({
  name: '',
  age: '',
  sex: 1,
  mingzhu: '汉族',
  pic: '',
  nativeplace: '',
  bysj: '',
  zhuanye:'',
  certificatenumber2: '',
  graduschool2: '北京长城学院',
  editer:'student',
})

const trainingUserInfo = ref({
  name: '',
  gender: 1,
  id_card_number: '',
  certificate_name: '',
  training_program: '',
  issue_date: '',
  grade: '合格',
  editer:'student',
  extra_field1: 'no',
})

const fetchGraduationCert = async () => {
  try {
    const res = await getCertificateList()
    if (res.code === 0 && res.data?.certicates) {
      const grad = res.data.certicates.graduationCert
      if (grad.id != 0) {
        
        graduationCert.value = {
          name: grad.major || '',
          no: grad.certificateNum || '',
          date: grad.date || '',
          publish: grad.publish || '',
          id:grad.id || 0,
        }
      }
      completionCertList.value = (res.data.certicates.completionCert || []).map(item => ({
        name: item.name || '',
        no: item.certificateNum || '',
        date: item.date || '',
        publish: grad.publish || '',
        id: item.id || 0,
      }))
    } else {
      ElMessage.error(res.msg || '获取学生信息失败')
    }
  } catch (err) {
    console.error('请求证书信息列表失败', err)
    ElMessage.error('请求证书信息列表失败')
  }
}


onMounted(async () => {
  // 获取学生信息
  //await studentStore.GetStudentInfo()
  //const stuRes = await getStudentInfo()
  
  let stuRes = {}
  const infoRes = await getStudentInfo()
  if (infoRes.code === 0 && infoRes.data?.userInfo) {
      studentStore.setStudentInfo(infoRes.data.userInfo)
      if (!infoRes.data.userInfo.name || !infoRes.data.userInfo.id_card_number) {
        router.push('/student/info').then(() => {
          
          ElMessage.error({
            message: '请先更新姓名和身份证号',
            duration: 5000
          });

          setTimeout(() => {
            location.reload()
          }, 5000)
        
        return
      })
      
    }
    stuRes = infoRes.data.userInfo
  } 
  // 填充表单默认值（不可编辑）
  userInfo.value.name = stuRes.name
  userInfo.value.certificatenumber2 = stuRes.id_card_number

  trainingUserInfo.value.name = stuRes.name
  trainingUserInfo.value.id_card_number = stuRes.id_card_number

  // 获取证书信息
  fetchGraduationCert()
})

const closeAddUserDialog = () => {
  userForm.value.resetFields()
  addUserDialog.value = false
}
const addUser = () => { addUserDialog.value = true }

const closeAddTrainingUserDialog = () => {
  trainingUserForm.value.resetFields()
  addTrainingUserDialog.value = false
}
const addTrainingUser = () => { addTrainingUserDialog.value = true }

const enterAddUserDialog = async () => {
  try {

    if(userInfo.value.age == ''){
      ElMessage.error('请填写正确出生年月日')
      return
    }
    if(userInfo.value.pic == ''){
      ElMessage.error('请先上传证件照信息')
      return
    }
    if(userInfo.value.nativeplace == ''){
      ElMessage.error('请选择您的籍贯')
      return
    }

    if(userInfo.value.zhuanye == ''){
      ElMessage.error('请输入专业信息')
      return
    }
    if(userInfo.value.bysj == ''){
      ElMessage.error('请输入正确的毕业时间')
      return
    }

    const res = await insertZhengshu(userInfo.value)
    if (res.code === 0) {
      ElMessage.success('创建成功')
      closeAddUserDialog()
      fetchGraduationCert()
    }
  } catch {
    ElMessage.error('提交失败，请重试')
  }
}

const enterAddTrainingUserDialog = async () => {
  try {
    const res = await insertTrainStu(trainingUserInfo.value)
    if (res.code === 0) {
      ElMessage.success('创建成功')
      closeAddTrainingUserDialog()
      fetchGraduationCert()
    }
  } catch {
    ElMessage.error('提交失败，请重试')
  }
}

function viewDetails(type,id) {
  const queryParams = new URLSearchParams({ type, id }).toString()
  let fullPath = ''
  if(type === 'certificate') {
    fullPath = `#/layout/business/certificate/certificateInfo?${queryParams}`
  } else if(type === 'train'){
    fullPath = `#/layout/trainingBusiness/training/trainingInfo?${queryParams}`
  }
  window.open(fullPath, '_blank')
}
</script>


<style scoped>
.gva-card {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.cert-card {
  flex: 1;
  min-width: 300px;
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

.warning-bar-text {
  color: red;
  white-space: pre-line;
}
.multiline-warning span {
  white-space: pre-line;
}
</style>
